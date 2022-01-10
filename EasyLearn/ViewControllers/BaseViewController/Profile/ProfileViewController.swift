//
//  ProfileViewController.swift
//  EasyLearn
//
//  Created by MacBook on 14.09.21.
//

import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var videosCountLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var editBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        bindNavigation()
    }

    private func bindNavigation() {
        editBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = EditViewController.getInstance(from: .base)
                vc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                self?.navigationController?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        avatarImageView.contentMode = .scaleToFill
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.easyPurple.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        navigationController?.navigationBar.tintColor = .systemBackground
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! ProfileTableViewCell
        return cell
    }
}

extension ProfileViewController: EditViewControllerDelegate {
    func didSave(user: User) {
        avatarImageView.image = user.image
        usernameLabel.text = user.name
        videosCountLabel.text = String(user.videos.count)
    }
}
