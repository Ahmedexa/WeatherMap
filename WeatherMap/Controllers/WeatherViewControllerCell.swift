//
//  WeatherViewControllerCell.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 15/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewControllerCell: UICollectionViewCell {
    static let identifier = "WeatherDayCell"
    
    @IBOutlet weak var iconLable: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var dayLeble: UILabel!
    
    
    func fillCell(waetherDay: Datum) {
        iconLable.text = GetIcon(waetherDay.icon ?? "")
        summaryLabel.text = waetherDay.summary
        tempLable.text = String(format:"%.0f", waetherDay.temperatureLow ?? "?")
        let date = NSDate(timeIntervalSince1970: TimeInterval(Int(waetherDay.time!)))
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "E d"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        dayLeble.text = dateString
        
        iconLable.textDropShadow()
        summaryLabel.textDropShadow()
        tempLable.textDropShadow()
        dayLeble.textDropShadow()
    }
}
