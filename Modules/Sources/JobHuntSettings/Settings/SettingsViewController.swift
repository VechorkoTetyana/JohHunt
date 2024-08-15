import UIKit
import DesignKit
import SnapKit
import JobHuntCore

public final class SettingsViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case header = 0
        case rowsOfOptions = 1
        case logout = 2
    }
    
    struct Model {
        let label: String
        let imageIcon: UIImage
        }
    
    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private weak var tableView: UITableView!
    
    var accauntSettingOptions: [Model] = []
    
    public var viewModel: SettingsViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        accauntSettingOptions = options()
        configureTableView()
        
        viewModel.didUpdateHeader = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchUserProfile()
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsHeaderCell.self, forCellReuseIdentifier: SettingsHeaderCell.identifier)
        tableView.register(AccountButtonCell.self, forCellReuseIdentifier: AccountButtonCell.identifier)
    }
    
    private func options() -> [Model] {
        
        var options = [Model]()
        
        options.append(Model(
            label: "Notification",
            imageIcon: .notification
        ))
        
        options.append(Model(
            label: "Theme",
            imageIcon: .theme
        ))
        
        options.append(Model(
            label: "HelpCenter",
            imageIcon: .helpCenter
        ))
        
        options.append(Model(
            label: "RateOurApp",
            imageIcon: .rateOurApp
        ))
        
        options.append(Model(
            label: "TermOfService",
            imageIcon: .termOfService
        ))
        
        return options
    }
}

extension SettingsViewController {
    
    private func setupUI() {
        setupNavigationTitle()
        setupTableView()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.title
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        self.tableView = tableView
    }
}

extension SettingsViewController: UITableViewDataSource {
    public func numberOfSections(in goodReadsUITableView: UITableView) -> Int {
        Row.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let row = Row(rawValue: section) else { return 0 }
        
        switch row {
        case .header:
            return 1
        case .rowsOfOptions:
            return accauntSettingOptions.count
        case .logout:
            print("Logout button tapped")
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Row(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHeaderCell.identifier, for: indexPath) as? SettingsHeaderCell
            
            cell?.configure(with: viewModel.header)
            
            return cell ?? UITableViewCell()
            
        case .rowsOfOptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountButtonCell.identifier, for: indexPath) as? AccountButtonCell
            
            let option = options()[indexPath.row]
            let accountCellModel = AccountButtonCell.Model(
                icon: option.imageIcon,
                title: option.label
            )
            
            cell?.configure(with: accountCellModel)

            return cell ?? UITableViewCell()
            
        case .logout:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountButtonCell.identifier, for: indexPath) as? AccountButtonCell
            else { return UITableViewCell() }
            cell.configure(with: .logout)
            cell.titleLbl.textColor = .darkRed
            
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Row(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return 128
        case .rowsOfOptions, .logout:
            return 56
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = ProfileEditViewModel(container: viewModel.container)
        let controller = ProfileEditViewController()
        
        guard let section = Row(rawValue: indexPath.section) else { return }

        switch section {
        case .header:
            controller.viewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)

        case .rowsOfOptions:
            print("Break")
            
        case .logout:
            didRequestLogout()
        }
    }
    
    private func didRequestLogout() {
        let alert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
            self?.didConfirmLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func didConfirmLogout() {
        do {
            try viewModel.logout()
        } catch {
            showError(error.localizedDescription)
        }
    }
}
