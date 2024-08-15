import UIKit
import DesignKit
import Swinject
import JobHuntAuthentication
import JobHuntSettings

class TabBarController: UITabBarController {
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .tabColor
        tabBar.tintColor = .accent
    }
        
    private func setupViewControllers() {
        let home = UIViewController()
        home.tabBarItem = Tab.home.tabBarItem
        
        let jobs = UIViewController()
        jobs.tabBarItem = Tab.jobs.tabBarItem
        
        let messages = UIViewController()
        messages.tabBarItem = Tab.messages.tabBarItem

        let account = setupAccount()
        
        viewControllers = [
            home,
            jobs,
            messages,
            account
        ]
        
        selectedViewController = account
    }
    
    private func setupAccount() -> UIViewController {
 
        let viewModel = SettingsViewModel(
           container: container
        )
        
        let settings = SettingsViewController(viewModel: viewModel)
        settings.viewModel = viewModel
        
        let settingsNav = UINavigationController(rootViewController: settings)
        settings.tabBarItem = Tab.account.tabBarItem
        settings.title = Tab.account.tabBarItem.title
        
        return settingsNav
    }
}
