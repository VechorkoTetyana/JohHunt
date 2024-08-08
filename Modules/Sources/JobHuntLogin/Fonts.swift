import UIKit

public enum Fonts: String {
    case urbanistBold = "Urbanist-Bold"
    case urbanistMedium = "Urbanist-Medium"
}

public extension UIFont {
 
    static var title: UIFont {
        UIFont(name: Fonts.urbanistMedium.rawValue, size: 28)!
    }
    
    static var title1: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 28)!
    }
    
    static var subtitle: UIFont {
        UIFont(name: Fonts.urbanistMedium.rawValue, size: 16)!
    }
    
    static var subtitle2: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 16)!
    }
    
    static var titleP1: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 18)!
    }
    
    static var titleP2: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 14)!
    }
    
    static var textField: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 24)!
    }
    
    static var titleOTP: UIFont {
        UIFont(name: Fonts.urbanistBold.rawValue, size: 32)!
    }
}
