import UIKit

public extension UINavigationController {
    func styleJobHunt() {
        navigationBar.tintColor = .primary

        let image = UIImage(resource: .angleArrowLeft)

        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image

        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}

