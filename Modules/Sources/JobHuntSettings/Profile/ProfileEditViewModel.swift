import UIKit
import Swinject
import JobHuntAuthentication
import JobHuntCore

enum TextFieldType1 {
    case name
    case location
}

enum Row1 {
    case profilePicture
    case textField(TextFieldType1)
}

public final class ProfileEditViewModel {
    
    var selectedImage: UIImage?
    var companyName: String = ""
    var location: String = ""
    var profilePictureUrl: URL?
    
    let container: Container
    
    var rows1: [Row1] = []
    
    var authService: AuthService {
        container.resolve(AuthService.self)!
    }
    var userRepository: UserProfileRepository {
        container.resolve(UserProfileRepository.self)!
    }
    var profilePictureRepository: ProfilePictureRepository {
        container.resolve(ProfilePictureRepository.self)!
    }

   public init(container: Container) {
        self.container = container
        
        if let profile = userRepository.profile {
            companyName = profile.companyName
            location = profile.location ?? "California, CA"
            profilePictureUrl = profile.profilePictureUrl
        }
       
        configureRows()
    }
    
    private func configureRows() {
            self.rows1 = [
                .profilePicture,
                .textField(.name),
            ]
        }
    
    func save() async throws {
        let profile = UserProfile(
            companyName: companyName,
            location: location,
            profilePictureUrl: nil
        )
        
        print("UserProfile saving or smth")
        
        try userRepository.saveUserProfile(profile)
        
        if let selectedImage {
            try await profilePictureRepository.upload(selectedImage)
        }
    }
    
    func modelForTextFieldRow(_ type: TextFieldType1) -> ProfileTextFieldCell.Model {
        switch type {
        case .name:
            ProfileTextFieldCell.Model(
                placeholder: "Your company display name",
                header: "Company Name",
                text: companyName,
                isValid: isFullNameValid()
            )
        case .location:
            ProfileTextFieldCell.Model(
                placeholder: "Your company location",
                header: "Location",
                text: location,
                isValid: isLocationValid()
            )
        }
    }
        
        private func isFullNameValid() -> Bool {
            companyName.count > 2
        }
    
    private func isLocationValid() -> Bool {
        location.count > 2
    }
}
