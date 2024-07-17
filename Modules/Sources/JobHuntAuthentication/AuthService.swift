import Foundation
import FirebaseAuth

// https://github.com/firebase/firebase-ios-sdk

public enum AuthError: Error {
    case noVerificationID
}

public struct User {
    public let uid: String
}

enum UserDefaultKey: String {
    case authVerificationID
}

public protocol AuthService {
    func requestOTP(forPhoneNumber phoneNumber: String) async throws
    func authenticate(withOTP otp: String) async throws -> User
}

final public class AuthServiceLive: AuthService {
    
    public init() {}
    
    public func requestOTP(forPhoneNumber phoneNumber: String) async throws {
        
        let verificationID = try await  PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
   
        UserDefaults.standard.set(verificationID, forKey: UserDefaultKey.authVerificationID.rawValue)
    }
    
    public func authenticate(withOTP otp: String) async throws -> User {
        
        guard let verificationID = UserDefaults.standard.string(forKey: UserDefaultKey.authVerificationID.rawValue) else {
            throw AuthError.noVerificationID
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        
        let result = try await Auth.auth().signIn(with: credential)
        result.user.uid
        
        return User(uid: result.user.uid)
    }
}
