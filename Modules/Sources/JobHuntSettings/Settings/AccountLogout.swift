import UIKit
import DesignKit

extension AccountButtonCell.Model {
    static var logout: Self {
        Self(
            icon: UIImage(resource: .logout),
            title: ProfileEditStrings.logout.rawValue
        )
    }
}
