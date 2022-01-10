//
//  SearchViewController.swift
//  EasyLearn
//
//  Created by MacBook on 24.08.21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchTextField: SearchTextField!

    private lazy var searchIconImage: UIImageView = {
        let searchIconImage = UIImageView(frame: CGRect(x: 8, y: 1, width: 18, height: 18))
        let searchImage = UIImage(named: "search")
        searchIconImage.image = searchImage
        return searchIconImage

    }()

    private lazy var searchIcon: UIView = {
        let searchIcon = UIView(frame: CGRect(x: 0, y: 0, width: 31, height: 20))
        searchIcon.addSubview(searchIconImage)
        return searchIcon
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupTextfield()
//        tableView.reloadData()
    }

    private func setupTextfield() {
        searchTextField.layer.cornerRadius = 10.0
        searchTextField.backgroundColor = UIColor.searchTextFieldColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        searchTextField.leftView = searchIcon
        searchTextField.leftViewMode = .always
        searchTextField.attributedPlaceholder = NSAttributedString(
                    string: "Search",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.easyGray])
    }
}

extension SearchViewController: UITableViewDelegate {}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        return cell
    }


}
