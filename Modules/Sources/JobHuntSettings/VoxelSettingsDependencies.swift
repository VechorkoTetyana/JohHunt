import Foundation
import JobHuntAuthentication

public protocol JobHuntSettingsDependencies {
    var authService: AuthService { get }
    var userRepository: UserProfileRepository { get }
    var profilePictureRepository: ProfilePictureRepository { get }
    
}
