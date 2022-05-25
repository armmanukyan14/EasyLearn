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

//protocol EditViewControllerDelegate: AnyObject {
//    func didSave(user: User)
//}

// MARK: - Class

class EditViewController: UIViewController {
    
    // MARK: - Delegate
    
    //    weak var delegate: EditViewControllerDelegate?
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let userDefaultsHelper = UserDefaultsHelper.shared
    let storage = Storage.storage().reference()
    let profileHeader = ProfileCollectionViewHeader()
    
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
        usernameTextField.text = Auth.auth().currentUser?.displayName
        
        let imagesRef = storage.child("images")
        if let uid = Auth.auth().currentUser?.uid {
            let imageRef = imagesRef.child(uid)
            imageRef.getData(maxSize: 1 * 2048 * 2048) { [weak self] data, error in
                if let data = data, error == nil {
                    let image = UIImage(data: data)
                    self?.avatarImageView.image = image
                } else {
                    let image = UIImage(named: "addPhoto")
                    self?.avatarImageView.image = image
                }
            }
        }
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
            self?.userDefaultsHelper.set(isLoggedIn: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        if let username = Auth.auth().currentUser?.displayName {
        alert.setValue(NSAttributedString.setAlert(title: "Log out of \(username)?"),
                       forKey: "attributedTitle")
        }
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
                
                if let image = self?.avatarImageView.image,
                   let imageData = image.pngData(),
                   let uid = Auth.auth().currentUser?.uid,
                   let imagesRef =  self?.storage.child("images") {
                    
                    let imageRef = imagesRef.child(uid)
                    
                    imageRef.putData(imageData, metadata: nil)
                    
//                    imageRef.downloadURL { url, error in
//                        if let url = url,
//                           error == nil {
//                            UserDefaults.standard.setValue(url, forKey: uid)
//                        }
//                    }
                }
                
                if let username = self?.usernameTextField.text {
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    //                changeRequest?.photoURL = url
                    changeRequest?.commitChanges { error in
                        guard let error = error else { return }
                        print(error.localizedDescription)
                    }
                }
                
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        logOutButton.rx.tap
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
    }
}
