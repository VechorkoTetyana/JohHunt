import UIKit
import DesignKit
import SDWebImage

class ProfileEditPictureCell: UITableViewCell {
    
    struct Model {
        let title: String
        let button: UIButton
        
        init(
            title: String,
            button: UIButton
        ) {
            self.title = title
            self.button = button
        }
    }
    
    private weak var profileImageView: UIImageView!
    private weak var setNewAvatarBtn: UIButton!
    private weak var titleLbl: UILabel!
    private weak var changeBtn: UIButton!
    
    var didTap: (()->())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with model: Model) {
        titleLbl.text = model.title
        changeBtn = model.button
    }
    
    func configure(with image: UIImage) {
        profileImageView.image = image
    }
    
    func configure(with url: URL) {
        profileImageView.sd_setImage(with: url)
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension ProfileEditPictureCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        configureContenteView()

        setupProfileImage()
        profilePictureChangeBtn()
        setupProfilePictureTitle()
    }
    
    private func configureContenteView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupProfilePictureTitle() {
        let label = UILabel()
        label.textColor = .black
        label.font = .title1
        label.text = "Profile Picture"
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.top).offset(-12)
            make.left.equalToSuperview()
        }
        self.titleLbl = label
    }
    
    private func profilePictureChangeBtn() {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .titleP2
        button.setTitleColor(.accent, for: .normal)
        button.setTitleColor(.accent, for: .highlighted)
        button.setTitleColor(.accent, for: .selected)
        button.setTitle(ProfileEditStrings.change.rawValue, for: .normal)
        button.addTarget(self, action: #selector(didTapBtn), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.top).offset(-12)
            make.right.equalToSuperview()
        }
        
        self.setNewAvatarBtn = button
    }
    
    private func setupProfileImage() {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(resource: .container)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
            make.size.equalTo(120)
        }
        
        self.profileImageView = imageView
    }
    
    @objc
    private func didTapBtn() {
        didTap?()
    }
}
