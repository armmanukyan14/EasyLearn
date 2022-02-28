//
//  EditViewController.swift
//  EasyLearn
//
//  Created by MacBook on 15.12.21.
//

import Firebase
import FirebaseStorage
import RxSwift
import UIKit

// MARK: - Protocol

protocol EditViewControllerDelegate: AnyObject {
    func didSave(user: User)
}

// MARK: - Class

class EditViewController: UIViewController {
    
    // MARK: - Delegate

    weak var delegate: EditViewControllerDelegate?

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let userDefaultsHelper = UserDefaultsHelper.shared
    let storage = Storage.storage().reference()

    // MARK: - Outlets

    @IBOutlet var customNavigationBar: UINavigationBar!
    @IBOutlet private var backButton: UIBarButtonItem!
    @IBOutlet private var saveButton: UIBarButtonItem!
    @IBOutlet private var editPhotoButton: UIButton!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var usernameLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationBar()
        bindNavigation()
        closeKeyboardWhenTapped()
    }

    // MARK: - Methods

    func setupNavigationBar() {
        customNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        customNavigationBar.shadowImage = UIImage()
    }

    private func setupViews() {
        editPhotoButton.layer.cornerRadius = 10.0
        logOutButton.layer.cornerRadius = 10.0
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        UITextField.setupTextField(placeholder: "Username", textField: usernameTextField)
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.setValue(NSAttributedString.setAlert(title: "Please add your profile photo."),
                             forKey: "attributedTitle")
        UIAlertController.setAlertButtonColor()
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel tapped")
        }))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        present(actionSheet, animated: true)
    }

    private func logOut() {
        let auth = Auth.auth()
        let vc = WelcomeViewController.getInstance(from: .main)
        do {
            try auth.signOut()
            (UIApplication.shared.windows
                .filter { $0.isKeyWindow }
                .first?.rootViewController as? UINavigationController)?
                            .setViewControllers([vc], animated: false)
            dismiss(animated: true)
        } catch {
            print("logOut error")
        }
    }

    private func showLogOutAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { [weak self] _ in
            self?.logOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.setValue(NSAttributedString.setAlert(title: "Log out of [username]?"),
                       forKey: "attributedTitle")
        UIAlertController.setAlertButtonColor()

        present(alert, animated: true)
    }

    // MARK: - Reactive

    private func bindNavigation() {
        editPhotoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showActionSheet()
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let image = self?.avatarImageView.image,
                      let username = self?.usernameTextField.text
                else { fatalError() }

                let user = User(name: username, image: image, videos: [])

                self?.delegate?.didSave(user: user)

                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        logOutButton.rx.tap
            .do(onNext: { [weak self] in
                self?.userDefaultsHelper.set(isLoggedOut: true)
            })
            .subscribe(onNext: { [weak self] in
                self?.showLogOutAlert()
            })
            .disposed(by: disposeBag)
    }

    private func closeKeyboardWhenTapped() {
        let tapBackground = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackground)
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else { return }

        avatarImageView.image = image

        guard let imageData = image.pngData()
        else { return }

        storage.child("images/file.png").putData(imageData, metadata: nil, completion: { [weak self] _, error in
            guard error == nil
            else {
                print("Failed to upload")
                return
            }
            self?.storage.child("images/file.png").downloadURL(completion: { url, error in
                guard let url = url, error == nil
                else { return }

                let urlString = url.absoluteString
                UserDefaults.standard.set(urlString, forKey: "imageUrl")

            })
        })
    }
}
