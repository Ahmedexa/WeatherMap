//
//  DataCore.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 14/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    static let shared = DataController()
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "WeatherMap")
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
