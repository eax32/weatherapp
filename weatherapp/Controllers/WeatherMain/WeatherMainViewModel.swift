//
//  WeatherMainPresenter.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit
import Reachability

class WeatherMainViewModel: NSObject {
    var listener: (()->Void)? = nil
    
    var cities = [CityDataModel]() {
        didSet {
            for city in cities {
                //  Request update for weather
                BackendManager.defaultManager.weatherFor(id: city.cityID, model: city, cb: { (data, model) in
                    model.cityData = data
                    LocalStorage.defaultStorage.updateCity(data: data)
                })
            }
            listener?()
        }
    }
    
    override init() {
        super.init()
        LocalStorage.defaultStorage.initDefaultsIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)), name: Notification.Name.reachabilityChanged, object: BackendManager.defaultManager.reachability)
    }
    
    func update() {
        LocalStorage.defaultStorage.getCities { (result) in
            self.cities = result.map({
                return CityDataModel(cityData: $0)
            })
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .none {
            update()
        } else {
            print("Network not reachable")
        }
    }
}
