import UIKit
import DesignKit

class FirstProfileCell: UITableViewCell {
    
  public struct Model {
        let title1: String
        let title2: String
        
      init(
        title1: String,
        title2: String
      ) {
          self.title1 = title1
          self.title2 = title2
      }
    }
    
    private weak var titleLbl1: UILabel!
    private weak var titleLbl2: UILabel!
    
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
        titleLbl1.text = model.title1
        titleLbl2.text = model.title2
    }
}

extension FirstProfileCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        configureContenteView()
        setupTitle1()
        setupTitle2()
    }
    
    private func configureContenteView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    private func setupTitle1() {
        let label = UILabel()
        label.textColor = .black
        label.font = .titleP1
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        titleLbl1 = label
    }
    
    private func setupTitle2() {
        let label = UILabel()
        label.textColor = .accent
        label.font = .titleP2
        
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        titleLbl2 = label
    }
}
