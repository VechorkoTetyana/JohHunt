import UIKit
import DesignKit

enum ProfileEditStrings: String {
    case profilePicture = "Profile picture"
    case change = "Change"
    case companyName = "Company name"
    case companyNamePlaceHolder = "Your company display name"
    case logout = "Log Out"
}

extension ProfileTextFieldCell.Model {
    
    static func companyName(text: String? = nil) -> Self {
        Self(
            placeholder: ProfileEditStrings.companyNamePlaceHolder.rawValue,
            header: ProfileEditStrings.companyName.rawValue,
            text: text,
            isValid: true
        )
    }
}

extension ButtonCell.Model {
    static var logout: Self {
        Self(
            icon: UIImage(resource: .logout),
            title: ProfileEditStrings.logout.rawValue
        )
    }
}

