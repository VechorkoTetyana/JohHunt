import UIKit
import Swinject
import JobHuntAuthentication
import JobHuntCore

public final class ProfileEditViewModel {
    
    var selectedImage: UIImage?
    var fullName: String = ""
    var description: String = ""
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

    init(
    container: Container
    ) {
        self.container = container
        
        if let profile = userRepository.profile {
            fullName = profile.fullName
            description = profile.description
            profilePictureUrl = profile.profilePictureUrl
        }
    }
    
    func save() async throws {
        let profile = UserProfile(
            fullName: fullName,
            description: description
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
