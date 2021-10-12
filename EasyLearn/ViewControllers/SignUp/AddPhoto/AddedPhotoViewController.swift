//
//  AddedPhotoViewController.swift
//  EasyLearn
//
//  Created by MacBook on 14.09.21.
//

import UIKit
import RxSwift

class AddedPhotoViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var completeSignUpButton: UIButton!
    @IBOutlet private var changePhotoButton: UIButton!
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        showActionSheet()
        bindNavigation()
        setupViews()
    }

    private func setupViews() {
        completeSignUpButton.layer.cornerRadius = 10.0
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.layer.masksToBounds = false
        userImageView.clipsToBounds = true
    }

    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)

        changePhotoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showActionSheet()
            })
            .disposed(by: disposeBag)

        completeSignUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let loginViewController = UIStoryboard.logIn.instantiateViewController(identifier: "LoginViewController")
                self?.navigationController?.pushViewController(loginViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func showActionSheet() {
        let actionSheet = UIAlertController(title: "Add photo", message: "Please add your profile photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
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
}

extension AddedPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        userImageView.image = image
    }
}
