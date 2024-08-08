import UIKit
import DesignKit

public final class ProfileTextFieldCell: UITableViewCell {
    
    struct Model {
        let placeholder: String
        let header: String
        let text: String?
        
        init(
            placeholder: String,
            header: String,
            text: String?
        ) {
            self.placeholder = placeholder
            self.header = header
            self.text = text
        }
    }
    
    weak var textField: UITextField!
    private weak var containerView: UIView!
    private weak var headerLbl: UILabel!
    private weak var footerLbl: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
    }
    
    func configure(with model: Model) {
        textField.placeholder = model.placeholder
        textField.text = model.text
        headerLbl.text = model.header
        
    }
}

extension ProfileTextFieldCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainer()
        setupTextField()
        setupHeader()
    }
    
    private func setupContainer() {
        let view = UIView()
        view.backgroundColor = .secondary
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(52)
        }
        self.containerView = view
    }
    
    private func setupTextField() {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .subtitle
        
        containerView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        self.textField = textField
    }
    
    private func setupHeader() {
        let label = UILabel()
        label.textColor = .black
        label.font = .titleP2
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(containerView.snp.top).offset(-8)
        }
        headerLbl = label
    }
}
