//
//  DarkSkyModel.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 13/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation

class DarkSky: Codable {
    let latitude, longitude: Double?
    let timezone: String?
    let currently: Currently?
    let daily: Daily?
    let offset: Double?

}

class Currently: Codable {
    let time: Int?
    let summary, icon: String?
    let temperature, apparentTemperature, dewPoint, humidity: Double?
    let pressure, windSpeed, windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility, ozone: Double?
}

class Daily: Codable {
    let summary, icon: String?
    let data: [Datum]?
    
}

class Datum: Codable {
    let time: Int?
    let summary, icon: String?
    let sunriseTime, sunsetTime: Int?
    let moonPhase, precipIntensity, precipIntensityMax: Double?
    let precipIntensityMaxTime: Int?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureHighTime: Int?
    let temperatureLow: Double?
    let temperatureLowTime: Int?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Int?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Int?
    let dewPoint, humidity, pressure, windSpeed: Double?
    let windGust: Double?
    let windGustTime, windBearing: Int?
    let cloudCover: Double?
    let uvIndex, uvIndexTime: Int?
    let visibility, ozone, temperatureMin: Double?
    let temperatureMinTime: Int?
    let temperatureMax: Double?
    let temperatureMaxTime: Int?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Int?
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Int?
    
}
