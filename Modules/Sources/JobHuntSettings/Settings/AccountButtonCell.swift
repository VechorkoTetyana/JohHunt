import UIKit
import DesignKit

class AccountButtonCell: UITableViewCell {
    
  public struct Model {
        let icon: UIImage
        let title: String
        
        init(
            icon: UIImage,
            title: String
        ) {
            self.icon = icon
            self.title = title
        }
    }
    
    private weak var iconImageView: UIImageView!
    private weak var titleLbl: UILabel!
    
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
        iconImageView.image = model.icon
        titleLbl.text = model.title
    }
}

extension AccountButtonCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        configureContenteView()
        setupiconImageView()
        setupTitle()
    }
    
    private func configureContenteView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupiconImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .container)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(24)
        }
        
        iconImageView = imageView
    }
    
    private func setupTitle() {
        let label = UILabel()
        label.textColor = .black
        label.font = .title2
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        titleLbl = label
    }
}
