import UIKit
import DesignKit
import SnapKit
import PhoneNumberKit

enum OTPText: String {
    case title = "Enter the OTP code"
    case subtitle = "To confirm the account, enter the 6-digit code we sent to  "
    case didntReceive = "Didn’t receive code?  "
    case resend = "Resend code"
    case submit = "Submit"
}

public final class OTPViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var continueBtn: UIButton!
    private var textFields: [UITextField] = []
    private weak var titleLabel: UILabel!
    private weak var fieldsLine: UITextField!
    
    var phoneNumber: String = ""
        
    public var viewModel: OTPViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureKeyboard()
        setupHideKeyboardGesture()
        continueBtn.alpha = 0.5
        textFields.first?.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupHideKeyboardGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension OTPViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupStackView()
        setupTitle()
        setupSubtitle()
        setupTextFields()
        setupContinueButton()
        setupResendLabel()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(0)
        }
        self.stackView = stackView
    }
    
    private func setupTitle() {
        let label = UILabel()
        label.textColor = UIColor(resource: .textField)
        label.text = OTPText.title.rawValue
        label.font = .titleOTP
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(label)
        
        self.titleLabel = label
    }
    
    private func setupSubtitle() {
        let label = UILabel()
        let string = NSMutableAttributedString()
        let subtitle = NSAttributedString(string: OTPText.subtitle.rawValue, attributes: [
                .font: UIFont.subtitle,
                .foregroundColor: UIColor(resource: .sub)
        ])
        string.append(subtitle)
        let phoneNumberLbl = NSAttributedString(string: phoneNumber, attributes: [
            .font: UIFont.subtitle2,
            .foregroundColor: UIColor(resource: .accent)
    ])
        string.append(phoneNumberLbl)
        
        label.attributedText = string
        label.numberOfLines = 2
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
    }
    
    private func setupTextFields() {
        var fields = [UITextField]()
        
        let fieldsStackView = UIStackView()
        fieldsStackView.axis = .horizontal
        fieldsStackView.distribution = .equalSpacing
        fieldsStackView.alignment = .center
        
        for index in 0...5 {
            let background = UIView()
            background.backgroundColor = .white
            background.layer.borderColor = UIColor(resource: .accent).cgColor
            background.layer.borderWidth = 2
            
            background.layer.cornerRadius = 14
            background.layer.masksToBounds = true
            
            let textField = UITextField()
            textField.textAlignment = .center
            textField.textColor = UIColor(resource: .textField)
            textField.font = .textField
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            textField.tag = 100 + index
            
            background.addSubview(textField)
            
            background.snp.makeConstraints { make in
                make.height.equalTo(48)
                make.width.equalTo(48)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            fieldsStackView.addArrangedSubview(background)
            fields.append(textField)
            
        }
        stackView.addArrangedSubview(fieldsStackView)
        
        fieldsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        view.layoutIfNeeded()
        
        textFields = fields
        self.fieldsLine = textFields.first
    }
    
    private func setupResendLabel() {
        let label = UILabel()
        let string = NSMutableAttributedString()
        let didntGetTheCode = NSAttributedString(string: OTPText.didntReceive.rawValue, attributes: [
                .font: UIFont.subtitle,
                .foregroundColor: UIColor(resource: .sub)
        ])
        string.append(didntGetTheCode)
        let resend = NSAttributedString(string: OTPText.resend.rawValue, attributes: [
            .font: UIFont.subtitle2,
            .foregroundColor: UIColor(resource: .accent)
    ])
        string.append(resend)
        
        label.attributedText = string
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fieldsLine.snp.bottom).offset(25)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardRectangle = keyboardFrame
            let keyboardHeight = keyboardRectangle.height
            
            print("Keyboard Height \(keyboardHeight)")
            
            let isKeyboardHidden = keyboardFrame.origin.y <= UIScreen.main.bounds.size.height
            
            // if keyboard is hidden
            let topMargin = isKeyboardHidden ? -40 : -keyboardHeight - 40
            
            stackView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(topMargin)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didChangeText(textField: UITextField) {
        let index = textField.tag - 100
        let nextIndex = index + 1
        textField.backgroundColor = UIColor(resource: .backgroundFrBtn)
        
        guard nextIndex < textFields.count else {
            didTapContinue()
            continueBtn.alpha = 1.0
            return
        }
        textFields[nextIndex].becomeFirstResponder()
    }
    
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
        
    private func setupContinueButton() {
        let button = UIButton()
        button.backgroundColor = .accent
        button.titleLabel?.font = .subtitle2
        
        button.titleLabel?.textColor = .primary
        
        button.setTitle(OTPText.submit.rawValue, for: .normal)
        
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(didTapContinueBtn), for: .touchUpInside)
        
        view.addSubview(button)
        
        stackView.addArrangedSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(306)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
        }
        view.layoutIfNeeded()
        
        self.continueBtn = button
    }
    
    @objc func didTapContinueBtn() {
        let otpVC = OTPViewController()
        navigationController?.pushViewController(otpVC, animated: true)
    }
}

extension OTPViewController {
    private func setContinueButtonDisabled() {
        continueBtn.isEnabled = false
        continueBtn.alpha = 0.5
    }
    
    private func setContinueButtonEnabled() {
        continueBtn.isEnabled = true
        continueBtn.alpha = 1
    }
    
    @objc func didTapContinue() {
        self.setContinueButtonDisabled()
        
        let digits = textFields.map { $0.text ?? "" }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.verifyOTP(with: digits)
                
                let vc = UIViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                
            } catch {
                self?.showError(error.localizedDescription)
                self?.setContinueButtonEnabled()
            }
        }
    }
}


