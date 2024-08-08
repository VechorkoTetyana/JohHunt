import UIKit
import Swinject
import JobHuntAuthentication
import JobHuntCore

public final class ProfileEditViewModel {
    
    var selectedImage: UIImage?
    var companyName: String = ""
    var location: String = ""
    var profilePictureUrl: URL? = nil
    
    let container: Container
    
    var authService: AuthService {
        container.resolve(AuthService.self)!
    }
    var userRepository: UserProfileRepository {
        container.resolve(UserProfileRepository.self)!
    }
    var profilePictureRepository: ProfilePictureRepository {
        container.resolve(ProfilePictureRepository.self)!
    }

   public init(
    container: Container
    ) {
        self.container = container
        
        if let profile = userRepository.profile {
            companyName = profile.companyName
            location = profile.location
            profilePictureUrl = profile.profilePictureUrl
        }
    }
    
    func save() async throws {
        let profile = UserProfile(
            companyName: companyName,
            location: location
        )
        
        try userRepository.saveUserProfile(profile)
        
        if let selectedImage {
            try await profilePictureRepository.upload(selectedImage)
        }
    }
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
}
