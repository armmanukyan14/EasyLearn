//
//  ProfileCollectionViewHeader.swift
//  EasyLearn
//
//  Created by MacBook on 31.01.22.
//

import UIKit
import Firebase

class ProfileCollectionViewHeader: UICollectionReusableView {

    // MARK: - Properties

    static let reuseIdentifier = "Header"
    static let kind = "header"

    // MARK: - Subviews

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 10

        return stackView
    }()

    let avatarImageView: UIImageView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let imageView = UIImageView()
        imageView.layer.masksToBounds = false
        imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.easyPurple.cgColor
        imageView.layer.borderWidth = 5

        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .easyDarkGray

        return label
    }()

    let videosCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .easyDarkGray
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()

    let lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .separator

        return lineView
    }()

    // MARK: - Layout
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 220),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            lineView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(videosCountLabel)
        stackView.addArrangedSubview(lineView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func set(username: String?) {
        usernameLabel.text = username
    }

    func set(videosCount: String?) {
        videosCountLabel.text = videosCount
    }

    func set(avatarImage: UIImage?) {
        avatarImageView.image = avatarImage
    }
}
