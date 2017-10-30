//
//  WeatherData.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit


extension Double {
    func convertTimeToString() -> String{
        let currentDateTime = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM hh:mm"
        return dateFormatter.string(from: currentDateTime)
    }
}

class WeatherData {
    var temp: Float = 0.0
    var pressure: Float = 0
    var date: String = ""
    var desc: String = ""

    //  Sugar
    var temp_i: Int {
        return Int(temp)
    }
    
    var temp_s: String {
        return String(temp) + " C"
    }
    
    static func fromJSON(_ info: [String: Any]) -> WeatherData {
        guard let main = info["main"] as? [String:Any] else {
            return WeatherData()
        }
        let dt = WeatherData()
        dt.temp = (main["temp"] as! NSNumber).floatValue
        dt.pressure = (main["pressure"] as! NSNumber).floatValue
        dt.date = (info["dt"] as! NSNumber).doubleValue.convertTimeToString()
        if let weatherFirst = (info["weather"] as? [[String:Any]])?.first,
            let wDesc = weatherFirst["description"] as? String
        {
            dt.desc = wDesc
        }
        return dt
    }
    
    func printInfo() {
        print("Temp: ", temp)
        print("Pressure: ", pressure)
        print("Date: ", date)
    }
}
