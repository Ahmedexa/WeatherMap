//
//  Model.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 13/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//


import Foundation
import UIKit

struct Photox: Codable {
    var id:String
    var secret:String
    var server:String
    var farm:Int
    //var url: String?
    
    func url() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
}

struct Photos: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Photox]
}

struct Flickr: Codable {
    let photos: Photos
    let stat: String
}


class ImageSize: Codable {
    let sizes: Sizes
    let stat: String
}

class Sizes: Codable {
    let canblog: Int
    let canprint: Int
    let candownload: Int
    let size: [Size]
}

class Size: Codable {
    let label: String
  //  let width: String
   // let height: String
    let source: String
    let url: String
    let media: String

}
