//
//  BackendManager.swift
//  weatherapp
//
//  Created by Kirill Bobkov on 30.10.17.
//  Copyright © 2017 NordrocksInc. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class BackendManager {
    static let defaultManager = BackendManager()
    
    var reachability: Reachability!
    
    enum TemperatureFormat: String {
        case Celsius = "metric"
        case Fahrenheit = "imperial"
        case Kelvin = ""
    }

    var temperatureFormat: TemperatureFormat = .Celsius {
        didSet {
            params["units"] = temperatureFormat.rawValue as AnyObject
        }
    }
    
    func searchCitiesBy(name: String, cb: @escaping ([CityData]) -> Void) {
        var p = params
        p["q"] = name
//        p["type"] = "like"
        
        Alamofire.request(Router.Find(p)).responseJSON(queue: DispatchQueue.main) { (response) in
            guard
                let value = response.value as? [String:Any],
                let cityList = value["list"] as? [[String:Any]] else
            {
                cb([])
                return
            }
            
            var data = [CityData]()
            for cityInfo in cityList {                              
                if let dt = CityData.fromJSON(cityInfo) {
                    dt.printInfo()
                    data.append(dt)
                }
            }
            cb(data)
        }
    }
    
    func weatherFor(id: Int64, model: CityDataModel, cb: @escaping (_ newData: CityData, _ model: CityDataModel) -> Void) {
        var p = params
        p["id"] = id
        Alamofire.request(Router.Weather(p)).responseJSON(queue: DispatchQueue.main) { (response) in
            guard let value = response.value as? [String:Any] else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                if let dt = CityData.fromJSON(value) {
                    dt.printInfo()
                    cb(dt, model)
                }
            })
        }
    }
    
    func forecastFor(id: Int64, cb: @escaping (_ forecast: [WeatherData], _ error: Bool) -> Void) {
        var p = params
        p["id"] = id        
        Alamofire.request(Router.ForeCast(p)).responseJSON(queue: DispatchQueue.main) { (response) in
            guard
                let value = response.value as? [String:Any],
                let forecastList = value["list"] as? [[String:Any]] else
            {
                cb([], true)
                return
            }            
            let w = forecastList.map({
                return WeatherData.fromJSON($0)
            })
            cb(w, false)
        }
    }
    

    
    private enum Router: URLRequestConvertible {
        func asURLRequest() throws -> URLRequest {
            let result: (Parameters) = {
                switch self {
                case .Find(let parameters): return parameters
                case .Weather(let parameters): return parameters
                case .ForeCast(let parameters): return parameters
                case .DailyForecast(params: let parameters): return parameters
                }
            }()
            
            let url = try (Router.baseURLString + Router.apiVersion).asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(self.path()))
            
            return try URLEncoding.default.encode(urlRequest, with: result)
        }
        
        static let baseURLString = "http://api.openweathermap.org/data/"
        static let apiVersion = "2.5"
        
        case Find([String:Any])
        case Weather([String: Any])
        case ForeCast([String: Any])
        case DailyForecast([String: Any])
        
        func path() -> String {
            switch self {
            case .Find: return "/find"
            case .Weather: return "/weather"
            case .ForeCast: return "/forecast"
            case .DailyForecast: return "/forecast/daily"
            }
        }
    }
    
    private var params = [String : Any]()
    
    private init() {
        params["appid"] = "7dfb579f2e702abd5046fe74638f376b"
        params["lang"] = "ru"
        params["units"] = "metric"
        
        reachability = Reachability()
        do {
            try reachability.startNotifier()
        }
        catch {
            print("could not start reachability notifier")
        }
    }
    
    private func parseWeatherInfo(_ info: [String: Any], to data: CityData) {
        guard let main = info["main"] as? [String:Any] else {
            return
        }
        
        data.temp = (main["temp"] as! NSNumber).floatValue
        data.pressure = (main["pressure"] as! NSNumber).floatValue
    }
}
