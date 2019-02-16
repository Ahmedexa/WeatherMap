//
//  weathericon.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 14/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//


import Foundation

func GetIcon(_ icon : String) -> String {
    
    switch icon {
    case "clear-day":
        return "\u{f00d}"
    case "clear-night":
        return "\u{f02e}"
    case "rain": //
        return "\u{f019}"
    case "snow": //
        return "\u{f01b}"
    case "sleet": //
        return "\u{f0b5}"
    case "wind":
        return "\u{f021}"
    case "strong-wind":
        return "\u{f050}"
    case "cloudy": //
        return "\u{f013}"
    case "fog": //
        return "\u{f014}"
    case "partly-cloudy-day": //
        return "\u{f002}"
    case "partly-cloudy-night": //
        return "\u{f031}"
        
    case "hail":
        return "\u{f015}"
    case "thunderstorm":
        return "\u{f01e}"
    case "tornado":
        return "\u{f056}"
    default:
        print ("   --------------  \(icon)")
        return "??"
    }

}
