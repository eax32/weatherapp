//
//  HeaderView.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit

class HeaderView: UIView, CityDataOwningProtocol {
    @IBOutlet var cityName: UILabel!
    @IBOutlet var temp: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var info: UILabel!
    
    func bindModel(model: CityDataModel) {
        model.bind(CityDataModel.UIOwner(owner: self))
    }
    
    func cityDataUpdated(_ data: CityData) {
        //  Update field
        cityName.text = data.title
        temp.text = "Температура: " + data.temp_s
        pressure.text = "Давление: " + String(data.pressure)
        info.text = "Погода: " + data.desc.capitalized
    }
}
