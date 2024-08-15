import UIKit
import DesignKit
import JobHuntCore

public final class ProfileEditViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case profilePicture = 0
        case companyName = 1
        case saveChanges = 2
    }
    
    private weak var tableView: UITableView!
    private weak var titleLbl: UILabel!
    private var footerView: UIView!
    
    var viewModel: ProfileEditViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureEditProfileLbl()
        configureTableView()
        setupHideKeyBoardGesture()
        subscribeToKeyboard()
        
        view.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ProfileEditPictureCell.self, forCellReuseIdentifier: ProfileEditPictureCell.identifier)
        tableView.register(ProfileTextFieldCell.self, forCellReuseIdentifier: ProfileTextFieldCell.identifier)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
    }
    
    private func configureEditProfileLbl() {
        let label = UILabel()
        label.text = "Edit profile"
        label.textColor = .black
        label.font = .titleP1
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        titleLbl = label
    }
}

extension ProfileEditViewController: UITextFieldDelegate {
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard
            let indexPath = tableView.indexPathForRow(
            at: textField.convert(
                textField.bounds.origin,
                to: tableView
            ))
        else { return }
        
        let row = viewModel.rows1[indexPath.row]
        
        guard case let .textField(type) = row else { return }
        
        switch type {
        case .name:
            viewModel.companyName = textField.text ?? ""
        case .location:
            viewModel.location = textField.text ?? ""
        }
                
        let cell = tableView.cellForRow(at: indexPath) as? ProfileTextFieldCell
        cell?.configure(with: viewModel.modelForTextFieldRow(type))
    }
}

// MARK: Keyboard

extension ProfileEditViewController {
    private func setupHideKeyBoardGesture() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyBoard)
        )
        tap.cancelsTouchesInView = false
       
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    private func subscribeToKeyboard() {
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
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let isKeyboardHidden = endFrame.origin.y >= UIScreen.main.bounds.size.height
        
        let bottomMargin = isKeyboardHidden ? 0 : -endFrame.height - 16
        
        tableView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(bottomMargin)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ProfileEditViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupTableView()
        configureTableView()
        setupSaveButton()
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(getStatusBarHeight())
            make.bottom.equalToSuperview().offset(-100)
        }
        
        self.tableView = tableView
    }
    
    private func setupSaveButton() {
        let button = UIButton(type: .custom)
        button.setTitle("Save changes", for: .normal)
        button.backgroundColor = .accent
        button.titleLabel?.font = .title2
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(335)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }

    @objc
    private func saveChangesButtonTapped() {
        print("Save changes button tapped")
        Task { [weak self] in
            do {
                try await self?.viewModel.save()
                self?.navigationController?.popViewController(animated: true)

            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    private func uploadProfilePicture(_ image: UIImage) async throws -> String {
       
        return "profilePicture/someName.jpg"
    }
    
    private func getStatusBarHeight() -> CGFloat {
       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return 0 }
        
        return windowScene.statusBarManager?.statusBarFrame.height ?? 0
    }
}

extension ProfileEditViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
            
        case .profilePicture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditPictureCell.identifier, for: indexPath) as? ProfileEditPictureCell
            else { return UITableViewCell() }
            
            if let selectedImage = viewModel.selectedImage {
                cell.configure(with: selectedImage)
            } else if let url = viewModel.profilePictureUrl {
                cell.configure(with: url)
            }
                        
            return cell
            
        case .companyName:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldCell.identifier, for: indexPath) as? ProfileTextFieldCell
            else { return UITableViewCell() }
            
            cell.configure(with: viewModel.modelForTextFieldRow(.name))
        
            cell.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
            return cell
            
        case .saveChanges:
            print("Save changes")
            return UITableViewCell()
        }
    }
}

extension ProfileEditViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        
        switch row {
            
        case .profilePicture:
            return 264
                        
        case .companyName:
            return 96
            
        case .saveChanges:
            return 196
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
            
        case .profilePicture:
            didTapProfilePicture()
            
        default:
            break
        }
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func didTapProfilePicture() {
        let alert = UIAlertController(title: "Select option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)

    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            viewModel.selectedImage = selectedImage
            
            tableView.reloadRows(at: [
                IndexPath(row: Row.profilePicture.rawValue, section: 0)
            ], with: .automatic)
        }
        picker.dismiss(animated: true)
    }
}
