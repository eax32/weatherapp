//
//  WeatherDetailsViewController.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit
import Reachability

class WeatherDetailsViewController: UIViewController {
    @IBOutlet var tableHeader: HeaderView!
    @IBOutlet var table: UITableView!
    @IBOutlet var descriptionLabel: UILabel!
    
    var cityModel: CityDataModel!
    var forecast = [WeatherData]() {
        didSet {
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: BackendManager.defaultManager.reachability)
        
        tableHeader.bindModel(model: cityModel)
        table.reloadData()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .none {
            fetchData()
        } else {
            print("Network not reachable")
        }
    }
    
    func fetchData() {
        BackendManager.defaultManager.forecastFor(id: cityModel.cityID) { (data, isError) in
            if isError {
                self.descriptionLabel.isHidden = false
                self.table.isHidden = true
                self.forecast = []
            }
            else {
                self.descriptionLabel.isHidden = true
                self.table.isHidden = false
                self.forecast = data
            }
        }
    }
}


extension WeatherDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell") as! CityTableViewCell
        let wm = forecast[indexPath.row]
        cell.name.text = wm.date
        cell.temp.text = "Температура: " + wm.temp_s + ", " + wm.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
