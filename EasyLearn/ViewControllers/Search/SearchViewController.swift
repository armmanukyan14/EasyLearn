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
        let imageView = UIImageView()
        let image = UIImage(named: "shape-1")
        imageView.image = image
        searchTextField.leftView = imageView
        searchTextField.leftViewMode = .always
        searchTextField.attributedPlaceholder = NSAttributedString(
                    string: "Search",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: searchTextField.frame.height))
//        searchTextField.leftView = padding
//        searchTextField.leftViewMode = .always
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
