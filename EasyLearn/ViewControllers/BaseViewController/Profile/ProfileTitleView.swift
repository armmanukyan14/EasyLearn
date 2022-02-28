//
//  ProfileTitleView.swift
//  EasyLearn
//
//  Created by MacBook on 27.02.22.
//

import UIKit

class ProfileTitleView: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8

        return stackView
    }()

    let avatarIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = false
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .easyPurple

        return imageView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .easyDarkGray
        label.text = "robert"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.translatesAutoresizingMaskIntoConstraints = false

//        backgroundColor = .red

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            avatarIconImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarIconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])

        stackView.addArrangedSubview(avatarIconImageView)
        stackView.addArrangedSubview(usernameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func set(username: String?) {
        usernameLabel.text = username
    }
}
