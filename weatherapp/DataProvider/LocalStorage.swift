//
//  LocalStorage.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit
import RealmSwift

class LocalStorage {
    static let defaultStorage = LocalStorage()
    
    var queue: OperationQueue!
    
    init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
    }

    func initDefaultsIfNeeded() {
        queue.addOperation {
            print("Initing DM")
            
            let realm = try! Realm()
            let rawObjects = realm.objects(CityDataRaw.self)
            
            var hasDefaults = false
            for city in rawObjects {
                print(city.cityID, city.country, city.name)
                if city.cityID == 524901 {
                    hasDefaults = true
                    break
                }
            }
            
            if !hasDefaults {
                print("Creating default cities")
                
                let msc = CityDataRaw()
                msc.cityID = 524901
                msc.name = "Moscow"
                msc.country = "RU"
                
                let spb = CityDataRaw()
                spb.cityID = 498817
                spb.name = "Saint Petersburg"
                spb.country = "RU"
                
                try! realm.write {
                    realm.add([msc, spb])
                }
            }
            
            print("Init completed")
        }
    }
    
    func getCities(cb: @escaping (_ result: [CityData]) -> Void) {
        queue.addOperation {
            print("Reading cities")
            
            let realm = try! Realm()
            let rawObjects = realm.objects(CityDataRaw.self)
            
            var cities = [CityData]()
            for city in rawObjects {
                print(city.cityID, city.country, city.name)
                let n = CityData()
                n.cityID = city.cityID.int64Value
                n.country = city.country
                n.name = city.name
                n.temp = city.temp.floatValue
                n.pressure = city.pressure.floatValue
                n.desc = city.desc
                cities.append(n)
            }
            
            DispatchQueue.main.async {
                cb(cities)
            }
        }
    }
    
    func addCity(data: CityData) {
        queue.addOperation {
            let realm = try! Realm()
            
            let n = CityDataRaw()
            n.cityID = NSNumber(value: data.cityID)
            n.name = data.name
            n.country = data.country
            n.temp = 0
            n.pressure = 0
            n.desc = data.desc
            
            try! realm.write {
                realm.add(n)
            }
        }
    }
    
    func updateCity(data: CityData) {
        queue.addOperation {
            let realm = try! Realm()
            if let rawObject = realm.objects(CityDataRaw.self).filter("cityID == " + String(data.cityID)).first {
                try! realm.write {
                    rawObject.temp = NSNumber(value: data.temp)
                    rawObject.pressure = NSNumber(value: data.pressure)
                    rawObject.desc = data.desc
                }
            }
        }
    }
}
