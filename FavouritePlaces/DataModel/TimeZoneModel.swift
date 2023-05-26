//
//  TimeZoneModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 25/5/2023.
//

import Foundation
import SwiftUI

struct MyTimeZone: Decodable {
    var timeZone:String
}
struct SunriseSunset: Codable {
    var sunrise:String
    var sunset:String
}
struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status: String?
}


extension Place {
    var timeZoneStr:String {
        if let tz = timeZone {
            return tz
        }
        fetchTimeZone()
        return ""
    }
    var sunriseStr:String {
        if let sr = sunriseTime {
            let localTM = timeConvertFromGMTtoTimeZone(from: sr, to: self.timeZoneStr)
            return "GMT:\(sr) Local:\(localTM)"
        }
        return ""
    }
    var sunsetStr:String {
        if let ss = sunsetTime {
            let localTM = timeConvertFromGMTtoTimeZone(from: ss, to: self.timeZoneStr)
            return "GMT:\(ss) Local:\(localTM)"
        }
        return ""
    }
    var timeZoneDisplay: some View {
        HStack {
            Image(systemName: "timer.square").foregroundColor(.blue)
            Text("Time Zone: ")
            if timeZoneStr != "" {
                Text(timeZoneStr)
            } else {
                ProgressView()
            }
        }
        
    }
    var sunriseDisplay: some View {
        HStack {
            Image(systemName: "sunrise.fill").foregroundColor(.blue)
            Text(" Sunrise ")
            if sunriseStr != "" {
                Text(sunriseStr)
            } else {
                ProgressView()
            }
        }
        
    }
    var sunsetDisplay: some View {
        HStack {
            Image(systemName: "sunset.fill").foregroundColor(.blue)
            Text(" Sunset ")
            if sunsetStr != "" {
                Text(sunsetStr)
            } else {
                ProgressView()
            }
        }
        
    }
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
