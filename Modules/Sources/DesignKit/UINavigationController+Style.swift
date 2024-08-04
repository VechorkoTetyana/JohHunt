import UIKit

public extension UINavigationController {
/*    func styleJobHunt() {
        navigationBar.tintColor = .primary

        let image = UIImage(resource: .angleArrowLeft)

        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image

        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }*/
    
    static func styleJobHunt() {
        
        let appearence = UINavigationBar.appearance()
        
        appearence.tintColor = .accent
        
        let image = UIImage(resource: .right)
        
        appearence.backIndicatorImage = image
        appearence.backIndicatorTransitionMaskImage = image

        appearence.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
     }
}

