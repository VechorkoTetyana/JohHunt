import UIKit
import Swinject
import JobHuntAuthentication
import JobHuntCore

enum TextFieldType {
    case name
    case location
}

enum Row {
    case profilePicture
    case textField(TextFieldType)
}

public final class SettingsViewModel {
    
    struct Header {
        let imageUrl: URL?
        let name: String
        let description: String
    }
    var selectedImage: UIImage?
    var companyName: String = ""
    var location: String = ""
    var profilePictureUrl: URL?
    
    var header: Header
    var rows: [Row]
    
    private let authService: AuthService
    private let userProfileRepository: UserProfileRepository
    private let profilePictureRepository: ProfilePictureRepository
    let container: Container
    
    var didUpdateHeader: (() -> ())?
    
    public init(
     container: Container
     ) {
         self.container = container
         self.authService = container.resolve(AuthService.self)!
         self.userProfileRepository = container.resolve(UserProfileRepository.self)!
         self.profilePictureRepository = container.resolve(ProfilePictureRepository.self)!
         
         if let profile = userProfileRepository.profile {
             companyName = profile.companyName
             location = profile.location ?? "California, CA"
             profilePictureUrl = profile.profilePictureUrl
         }
         
         rows = [
             .profilePicture,
             .textField(.name),
             .textField(.location)
         ]
         
         header = Header(
             imageUrl: nil,
             name: "Company",
             description: "Location not specified"
         )
     }
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
                
    var userRepository: UserProfileRepository {
        container.resolve(UserProfileRepository.self)!
    }
    
    func fetchUserProfile() {
        Task { [weak self] in
            do {
                guard let profile = try await self?.userRepository.fetchUserProfile() else { return }
                                
                await MainActor.run { [weak self] in
                    self?.updateHeader(with: profile)
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateHeader(with userProfile: UserProfile) {
        header = Header(
            imageUrl: userProfile.profilePictureUrl,
            name: userProfile.companyName,
            description: userProfile.location ?? "California, CA"
        )
        
        didUpdateHeader?()
    }
}
