//
//  AddCityViewController.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    
    var tableSource = [CityData]() {
        didSet {
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        BackendManager.defaultManager.searchCitiesBy(name: text) { (result) in
            self.tableSource = result
        }
    }
}


extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cm = tableSource[indexPath.row]
        var cell: UITableViewCell!
        if let deqCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") {
            cell = deqCell
        }
        else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell.textLabel?.text = cm.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalStorage.defaultStorage.addCity(data: tableSource[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
