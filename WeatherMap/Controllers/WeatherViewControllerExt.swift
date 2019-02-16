//
//  WeatherViewControllerExt.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 15/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}

func Alert (VC:UIViewController , title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    VC.present(alert, animated: true, completion: nil)
}
