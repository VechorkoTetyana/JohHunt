import UIKit
import Swinject
import JobHuntAuthentication
import JobHuntCore

enum position {
    case imageIcon
    case accountOption
}

public final class AccountCellModel {
    
    struct Model {
        let imageIcon: UIImage
        let description: String
    }
    
    var selectedImage: UIImage?
    var description: String = ""
    
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
        selectedImage: UIImage? = nil,
        description: String,
        container: Container
    ) {
        self.selectedImage = selectedImage
        self.description = description
        self.container = container
    }
    
    func logout() throws {
        try authService.logout()
        NotificationCenter.default.post(.didLogout)
    }
}
