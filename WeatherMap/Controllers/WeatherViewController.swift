//
//  ViewController.swift
//  WeatherMap
//
//  Created by Ahmed Alsamani on 13/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var weatherIconLable: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var forcastStackView: UIStackView!
    var fetchResult: NSFetchedResultsController<Photo>!
    
    var pin: Pin!
    var totalPages: Int? = nil
    var waetherDaily : [Datum] = []
    var backgroundPhotos : [UIImage] = []
    var RandBackground : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
        pin = API.shared.pin
        fetchPhotosFromDC(pin)
        self.view.clipsToBounds = true
        
        fetchResult?.fetchedObjects?.count == 0  ?  fetchPhotosFromAPI(pin) : print("d")

        getBackground()
        getWeather()
        transitionUpdate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        transitionUpdate()
        
    }
    
    func transitionUpdate()  {
        let screenSize: CGRect = UIScreen.main.bounds
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            backgroundImage.frame = CGRect(x: 0, y: -20, width: screenSize.width * 2, height: screenSize.height )
            stackView.axis  = NSLayoutConstraint.Axis.horizontal
        } else {
            print("Portrait")
            backgroundImage.frame = CGRect(x: 0, y: -20, width: screenSize.width, height: screenSize.height * 2 )
            stackView.axis  = NSLayoutConstraint.Axis.vertical
                
        }
    }
    
    func uiConfig()  {
        tempLable.textDropShadow()
        cityNameLable.textDropShadow()
        weatherIconLable.textDropShadow()
        summaryLabel.textDropShadow()
        
        self.activityIndicator.stopAnimating()
        self.cityNameLable.text = "  \(API.shared.cityName)"
        self.labelStatus.text = ""
    }
    
    func getWeather() {
        API.shared.GetWaether(latitude: pin.latitude, longitude: pin.longitude) { (waether, error) in
            DispatchQueue.main.async {
                self.labelStatus.text = "Get Weather Data .."
                guard waether != nil else {
                    print("\(#function) No Data ")
                    return
                }
                self.tempLable.text = String(format:"%.0f", waether?.currently?.temperature ?? 0)
                self.weatherIconLable.text =  GetIcon(waether?.currently?.icon ?? "")
                self.summaryLabel.text = waether?.currently?.summary
                self.waetherDaily = (waether?.daily?.data!)!
                
                self.collectionView.reloadData()
                self.labelStatus.text = ""
            }
        }
    }
    
    func getBackground() {
        guard (fetchResult.fetchedObjects?.count) != nil else {
            return
        }
        for photo in fetchResult.fetchedObjects! {
            downloadImage(photo)
            return
        }
    }
    
    func downloadImage(_ photo:Photo) {
            self.labelStatus.text = "Download Image .."
            self.activityIndicator.startAnimating()
            if  photo.imageData != nil {
                showBackground(photo)
                activityIndicator.stopAnimating()
                self.labelStatus.text = ""
            } else {
                guard photo.imageURL != nil else { return }
                
                API.shared.getImage(imageUrl: photo.imageURL!) { (data, error) in
                    
                    guard data != nil else { return }
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        photo.imageData = data
                        try? DataController.shared.viewContext.save()
                    }
                    
                    let photo = Photo(context: DataController.shared.viewContext)
                    photo.imageData = data
                    try? DataController.shared.viewContext.save()
                    self.showBackground(photo)
                }
                self.labelStatus.text = ""
            }
        }
    
    func showBackground(_ photo:Photo) {
        DispatchQueue.main.async {
            if let data = photo.imageData, let image = UIImage(data: data) {
                self.backgroundImage.image = image
            } else {
                self.backgroundImage.image = #imageLiteral(resourceName: "Blue-Sky")
            }

            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            self.backgroundImage.frame = CGRect(x: 50, y: 0, width: screenWidth, height: screenHeight)
            UIView.animate(withDuration: 15, delay: 0, options: [.repeat, .autoreverse] , animations: {
                 self.backgroundImage.frame = CGRect(x: -50, y: 0, width: screenWidth, height: screenHeight);
                }) { (completed) in
             }
        }
    }

    
    private func fetchPhotosFromDC(_ pin: Pin) {
        let fr = NSFetchRequest<Photo>(entityName: "Photo")
        fr.sortDescriptors = []
        fr.predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        fetchResult = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        var error: NSError?
        do {
            try fetchResult.performFetch()
            
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("Error performing initial fetch: \(error)")
        }
    }
    
    
    
    private func fetchPhotosFromAPI(_ pin: Pin) {
        print("\(#function) in ")
        activityIndicator.startAnimating()
        labelStatus.text = "Fetching photos ..."
        API.shared.FlickrPhotosSearch(latitude: pin.latitude, longitude: pin.longitude, totalPages: totalPages) { (Flickr, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.labelStatus.text = ""
                
                if let FlickrPhotos = Flickr {
                    self.totalPages = FlickrPhotos.photos.pages
                    let totalPhotos = FlickrPhotos.photos.photo.count
                    
                    for photo in FlickrPhotos.photos.photo  {
                        
                        API.shared.FlickrGetSizes(photoId: photo.id) { (Sizes, error) in
                            DispatchQueue.main.async {
                                print("\(#function) back2 ")
                                 if let PhotoSizes = Sizes {

                                    for size in PhotoSizes.sizes.size  {
                                        if size.label == "Large" {
                                            let item = Photo(context: DataController.shared.viewContext)
                                            item.imageURL = size.source
                                            item.pin = pin
                                            self.downloadImage(item)
                                        }
                                    }
                                
                                }
                            }
                        }
                    }
                    
                    do {
                        try DataController.shared.viewContext.save()
                        
                    } catch {
                        //   print(error)
                    }
                    
                    if totalPhotos == 0 {
                        self.labelStatus.text = "No Photos Found!"
                    }else{
                        DispatchQueue.main.async {
                            self.fetchPhotosFromDC(pin)
                            
                        }
                    }
                } else if let error = error {
                    print("error:\(error)")
                    self.labelStatus.text = "\(error)"
                    Alert(VC: self, title: "Error", message: "\(error)")
                }
            }
        }
    }
    
    
    func save() {
        try?  DataController.shared.viewContext.save()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  waetherDaily.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDayCell",for: indexPath) as! WeatherViewControllerCell
        cell.fillCell(waetherDay: waetherDaily[indexPath.row] )
        return cell
        
    }
    

}


