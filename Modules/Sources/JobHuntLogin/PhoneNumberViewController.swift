import UIKit
import DesignKit
import JobHuntAuthentication
import PhoneNumberKit
import SnapKit

enum PhoneNumberStrings: String {
    case title = "Log In"
    case subtitle = "Enter your phone number to continue"
    case continueButton = "Continue"
}

public final class PhoneNumberViewModel {
    var authService: AuthService
    
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    public func requestOTP(with phoneNumber: String) async throws {
        try await authService.requestOTP(forPhoneNumber: phoneNumber)
    }
}

public final class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueButton: UIButton!
    
    public var viewModel: PhoneNumberViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribeToTextChange()
        textFieldDidChange()
        
        textField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
}

extension PhoneNumberViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        setupStackView()
        setupIcon()
        setupTitle()
        setupSubtitle()
        setupTextField()
        setupContinueButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        self.stackView = stackView
    }
    
    private func setupIcon() {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(resource: .logo)
        
        stackView.addArrangedSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
    }
    
    private func setupTitle() {
        let label = UILabel()
        label.textColor = .black
        label.text = PhoneNumberStrings.title.rawValue
        label.font = .title1
        label.textAlignment = .center
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(label)
    }
    
    private func setupSubtitle() {
        let label = UILabel()
        label.textColor = UIColor(resource: .sub)
        label.text = PhoneNumberStrings.subtitle.rawValue
        label.font = .subtitle
        label.textAlignment = .center
        label.numberOfLines = 2
        
        stackView.addArrangedSubview(label)
        
        label.snp.makeConstraints { make in
            make.width.equalTo(232)
        }
    }
    
    private func setupTextField() {
        let textFieldBackground = UIView()
        textFieldBackground.backgroundColor = UIColor(resource: .backgroundFrBtn)
        textFieldBackground.layer.cornerRadius = 12
        textFieldBackground.layer.masksToBounds = true
        stackView.addArrangedSubview(textFieldBackground)
        
        textFieldBackground.snp.makeConstraints{ make in
            make.width.equalTo(335)
            make.height.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let textField = PhoneNumberTextField(
            insets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20),
            clearButtonPadding: 0)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.withFlag = true
        textField.font = .subtitle
        textField.textColor = .textField
        textField.withExamplePlaceholder = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number")
        textFieldBackground.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.center.equalToSuperview()
        }
        self.textField = textField
    }
    
    private func setupContinueButton() {
        let button = UIButton()
        button.backgroundColor = .accent
        button.titleLabel?.font = .subtitle2
       
        button.setTitle(PhoneNumberStrings.continueButton.rawValue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        stackView.addArrangedSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(335)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(20)
        }
        self.continueButton = button
    }
}

extension PhoneNumberViewController {
    @objc func textFieldDidChange() {
        print("Text Field Did Change!")
        continueButton.isEnabled = textField.isValidNumber
        continueButton.alpha = textField.isValidNumber ? 1.0 : 0.25
    }
}

extension PhoneNumberViewController {
    @objc func didTapContinue() {
        guard
            textField.isValidNumber,
            let phoneNumber = textField.text
        else { return }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.requestOTP(with: phoneNumber)
                
                self?.presentOTP()
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    private func presentOTP() {
        let viewController = OTPViewController()
        viewController.viewModel = OTPViewModel(authService: viewModel.authService)
 //       viewController.phoneNumber = textField.text ?? ""
        viewController.viewModel = OTPViewModel(authService: viewModel.authService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    func showError(_ error: String) {
           let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default))
           self.present(alert, animated: true)
       }
}

