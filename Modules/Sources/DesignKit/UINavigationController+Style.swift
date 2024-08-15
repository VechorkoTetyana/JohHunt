import UIKit

public extension UINavigationController {
    
    static func styleJobHunt() {
        
        let appearence = UINavigationBar.appearance()
        
        appearence.tintColor = .accent
        
        let image = UIImage(resource: .left)
        
        appearence.backIndicatorImage = image
        appearence.backIndicatorTransitionMaskImage = image

        appearence.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
     }
}

