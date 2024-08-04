import UIKit

enum Tab {
    case home
    case jobs
    case messages
    case account
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(title: "Home", image: .home, tag: 0)
        case .jobs:
            return UITabBarItem(title: "Jobs", image: .jobs, tag: 0)
        case .messages:
            return UITabBarItem(title: "Messages", image: .messages, tag: 0)
        case .account:
            return UITabBarItem(title: "Account", image: .account, tag: 0)
        }
    }
}
