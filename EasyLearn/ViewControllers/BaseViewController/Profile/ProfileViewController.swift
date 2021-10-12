//
//  ProfileViewController.swift
//  EasyLearn
//
//  Created by MacBook on 14.09.21.
//

import UIKit

class ProfileViewController: UIViewController {

    var user = User(name: "gurgen_14", image: UIImage(named: "berlin"), videos: [])

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var videosCountLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
    }

    private func setupViews() {
        videosCountLabel.text = String(user.videos.count)
        avatarImageView.contentMode = .scaleToFill
        avatarImageView.image = user.image
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.easyPurple.cgColor
        usernameLabel.text = user.name
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
