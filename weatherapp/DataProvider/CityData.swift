//
//  CityData.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit
import RealmSwift

class CityData {
    //  Fields
    var cityID: Int64 = 0
    var name: String = ""
    var country: String = ""
    var temp: Float = 0.0
    var pressure: Float = 0
    var desc: String = ""
    
    //  Sugar
    var title: String {
        return name + ", " + country
    }
    var temp_i: Int {
        return Int(temp)
    }
    var temp_s: String {
        return String(temp) + " C"
    }
    
    static func fromJSON(_ info: [String: Any]) -> CityData? {
        guard let main = info["main"] as? [String:Any] else {
            return nil
        }
        
        let dt = CityData()
        dt.cityID = (info["id"] as! NSNumber).int64Value
        dt.name = info["name"] as! String
        dt.country = (info["sys"] as! [String:Any])["country"] as! String
        dt.temp = (main["temp"] as! NSNumber).floatValue
        dt.pressure = (main["pressure"] as! NSNumber).floatValue
        
        if let weatherFirst = (info["weather"] as? [[String:Any]])?.first,
            let wDesc = weatherFirst["description"] as? String
        {
            dt.desc = wDesc
        }
        
        return dt
    }
    
    func printInfo() {
        print("City: ", cityID)
        print("Name: ", title)
        print("Temp: ", temp)
        print("Pressure: ", pressure)
        print("Desc: ", desc)
    }
}

class CityDataRaw: Object {
    @objc dynamic var cityID: NSNumber = 0
    @objc dynamic var name: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var temp: NSNumber = 0.0
    @objc dynamic var pressure: NSNumber = 0.0
    @objc dynamic var desc: String = ""
}

protocol CityDataOwningProtocol: class {
    func cityDataUpdated(_ data: CityData)
}

class CityDataModel {
    class UIOwner {
        weak var ptr: CityDataOwningProtocol? = nil
        init(owner: CityDataOwningProtocol?) {
            self.ptr = owner
        }
    }
    
    var cityID = Int64(0)
    var cityData: CityData? = nil {
        didSet {
            if let data = cityData {
                cityID = data.cityID                
                owners = owners.filter({ return $0.ptr != nil })
                for ow in owners {
                    ow.ptr?.cityDataUpdated(data)
                }
            }
        }
    }
    
    private var owners = [UIOwner]()
    
    func bind(_ owner: UIOwner) {
        owners = owners.filter({ return $0.ptr != nil })
        owners.append(owner)
        if let data = cityData {
            owner.ptr?.cityDataUpdated(data)
        }
    }
    
    init(cityData: CityData) {
        self.cityID = cityData.cityID
        self.cityData = cityData
    }
}
