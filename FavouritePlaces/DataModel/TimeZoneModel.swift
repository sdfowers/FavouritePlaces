//
//  TimeZoneModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 25/5/2023.
//

import Foundation
import SwiftUI

/// MyTimeZone struct for decoding timeapi.io
struct MyTimeZone: Decodable {
    var timeZone:String
}

/// SunriseSunset struct for encoding timeapi.io
struct SunriseSunset: Codable {
    var sunrise:String
    var sunset:String
}

/// SunriseSunsetAPI for encoding timeapi.io
struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status: String?
}

/// Extensions of Place class for added methods, accessing timeapi.io
extension Place {
    //Get and set timeZone as a string coverting from the timeapi.io.
    var timeZoneStr:String {
        if let tz = timeZone {
            return tz
        }
        fetchTimeZone()
        return ""
    }
    
    //Get and set sunrise as a string converting from the timeapi.io.
    var sunriseStr:String {
        if let sr = sunriseTime {
            let localTM = timeConvertFromGMTtoTimeZone(from: sr, to: self.timeZoneStr)
            return "GMT:\(sr) Local:\(localTM)"
        }
        return ""
    }
    
    //Get and set sunset as a string coverting from timeapi.io.
    var sunsetStr:String {
        if let ss = sunsetTime {
            let localTM = timeConvertFromGMTtoTimeZone(from: ss, to: self.timeZoneStr)
            return "GMT:\(ss) Local:\(localTM)"
        }
        return ""
    }
    
    //SwiftUI view of the timezone for easy adjustment.
    var timeZoneDisplay: some View {
        HStack {
            Image(systemName: "timer.square").foregroundColor(.blue)
            Text("Time Zone: ")
            if timeZoneStr != "" {
                Text(timeZoneStr)
            } else {
                ProgressView()      //If it cannot be loaded, display generic progressview
            }
        }
        
    }
    
    //SwiftUI view of the sunrise for easy adjustment.
    var sunriseDisplay: some View {
        HStack {
            Image(systemName: "sunrise.fill").foregroundColor(.blue)
            Text(" Sunrise ")
            if sunriseStr != "" {
                Text(sunriseStr)
            } else {
                ProgressView()      //If it cannot be loaded, display generic progressview
            }
        }
        
    }
    
    //SwiftUI view of the sunset for easy adjustment.
    var sunsetDisplay: some View {
        HStack {
            Image(systemName: "sunset.fill").foregroundColor(.blue)
            Text(" Sunset ")
            if sunsetStr != "" {
                Text(sunsetStr)
            } else {
                ProgressView()      //If it cannot be loaded, display generic progressview
            }
        }
        
    }
    
    //Fetch the timezone of the current latitude and longitude through timeapi.io
    func fetchTimeZone() {
        let urlStr = "https://www.timeapi.io/api/TimeZone/coordinate?latitude=\(self.latitude)&longitude=\(self.longitude)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let api = try? JSONDecoder().decode(MyTimeZone.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
                self.timeZone = api.timeZone
                self.fetchSunriseInfo()
            }
        }.resume()
    }
    
    //Fetch the sunrise info of the current latitude and longitude through timeapi.io
    func fetchSunriseInfo() {
        let urlStr = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longitude)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {
            data, _, _ in
            guard let data = data, let api = try? JSONDecoder().decode(SunriseSunsetAPI.self, from: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.sunriseTime = api.results.sunrise
                self.sunsetTime = api.results.sunset
            }
        }.resume()
    }
}

///Converts the GMT time to applicable timezone
func timeConvertFromGMTtoTimeZone(from tm:String, to timezone:String) -> String {
    let inputFormater = DateFormatter()
    inputFormater.dateStyle = .none
    inputFormater.timeStyle = .medium
    inputFormater.timeZone = .init(secondsFromGMT: 0)
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateStyle = .none
    outputFormatter.timeStyle = .medium
    outputFormatter.timeZone = TimeZone(identifier: timezone)
    
    if let time = inputFormater.date(from: tm) {
        return outputFormatter.string(from: time)
    }
    return "<unknown>"
}
