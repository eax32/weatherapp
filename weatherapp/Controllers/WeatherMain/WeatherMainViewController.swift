//
//  WeatherMainViewController.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController {
    @IBOutlet var table: UITableView!
    var viewModel: WeatherMainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        viewModel = WeatherMainViewModel()
        viewModel.listener = {
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.update()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let segueID = segue.identifier else {
            return
        }
        if segueID == "DetailsSegue" {
            if let controller = segue.destination as? WeatherDetailsViewController,
                let row = table.indexPath(for: sender as! CityTableViewCell)?.row {
                controller.cityModel = viewModel.cities[row]
            }
        }
    }
}


extension WeatherMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cm = viewModel.cities[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityTableViewCell
        cell.bindModel(model: cm)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
