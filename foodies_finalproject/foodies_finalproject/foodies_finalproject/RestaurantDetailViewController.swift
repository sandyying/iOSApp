//
//  RestaurantDetailViewController.swift
//  foodies_finalproject
//
//  Created by 应芮 on 2019/5/3.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import MapKit
import CoreLocation
var placeholdertext = ""
var wishlists = [NSManagedObject]()
var visitedlists = [NSManagedObject]()

class RestaurantDetailViewController: UIViewController {
    
    var errorPlayer: AVAudioPlayer?
    var savePlayer: AVAudioPlayer?
    
    func loadSound(filename: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
        var player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.prepareToPlay()
        } catch {
            print("Error loading \(url!): \(error.localizedDescription)")
        }
        return player
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = PassedName
        address.text = PassedAddress
        votes.text = PassedVotes + " Ratings"
        cost.text = "Average Cost: " + PassedCost
        image.image  = PassedPotrait
        let Searchrating = Float(PassedRating) ?? 0
        detailRating.rating = Int(round(Searchrating))
        phonenumber.text = PassedPhone
        var text1 = ""
        if PassedClosed == true{
            text1 = "Closed Now"
        }
        else{
            text1 = "Open Now"
        }
        closed.text = text1
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001,longitudeDelta: 0.001)
        let location = CLLocationCoordinate2DMake(PassedLat, PassedLong)
        print(PassedLat)
        print(PassedLong)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = PassedName
        map.addAnnotation(annotation)
        
        
        self.errorPlayer = self.loadSound(filename: "error_notification")
        self.savePlayer = self.loadSound(filename: "click")
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var detailRating: RatingControl!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var closed: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var address: UITextView!
    var Num = Int()
    var PassedName = String()
    var PassedAddress = String()
    var PassedReview = String()
    var PassedRating = String()
    var PassedPotrait = UIImage()
    var PassedVotes = String()
    var PassedCost = String()
    var PassedPhone = String()
    var PassedClosed = Bool()
    var PassedLong = Double()
    var PassedLat = Double()
    @IBAction func addWishList(_ sender: Any) {
        addWishList(name: PassedName, address: PassedAddress, image: PassedPotrait)
    }
    
    @IBAction func VisitedList(_ sender: Any) {
        
        addVisitedList(name: PassedName, address: PassedAddress, image: PassedPotrait)
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        if segue.identifier == "resReview" {
            placeholdertext = PassedName
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func checkWish(id: String) -> Bool {
        var wished = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"WishList")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            wished = results
        }
        
        for wish in wished {
            if (wish.value(forKey: "address") as! String) == id {
                return true
            }
        }
        return false
    }
    
    func checkVisit(id: String) -> Bool {
        var visited = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"VisitedList")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            visited = results
        }
        
        for visit in visited {
            if (visit.value(forKey: "address") as! String) == id {
                return true
            }
        }
        return false
    }
    
    
    func addWishList(name: String, address: String, image: UIImage){
        //check if already there
        if checkWish(id: address) {
            let alert = UIAlertController(title: "Error", message: "This was already previously saved.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
            
            //error sound
            self.errorPlayer?.play()
            
        } else {
            
            // create the alert
            let alert = UIAlertController(title: "Notification", message: "This restaurant has been added to wish list!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            //save sound
            self.savePlayer?.play()
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WishList", in: managedContext)
        
        let wishlist = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        wishlist.setValue(name, forKey: "name")
        wishlist.setValue(address, forKey: "address")
        
        //Use image name from bundle to create NSData
        //Now use image to create into NSData format
        let imageData:NSData = image.pngData()! as NSData
        wishlist.setValue(imageData, forKey: "image")
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        wishlists.append(wishlist)
        }
    }
    
    func addVisitedList(name: String, address: String, image: UIImage){
        if checkVisit(id: address) {
            let alert = UIAlertController(title: "Error", message: "This was already previously saved.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //error sound
            self.errorPlayer?.play()
            
        } else {
            // create the alert
            let alert = UIAlertController(title: "Notification", message: "This restaurant has been added to visited list!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            //save sound
            self.savePlayer?.play()
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "VisitedList", in: managedContext)
        
        let visitedlist = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        visitedlist.setValue(name, forKey: "name")
        visitedlist.setValue(address, forKey: "address")
        
        
        //Use image name from bundle to create NSData
        //Now use image to create into NSData format
        let imageData:NSData = image.pngData()! as NSData
        visitedlist.setValue(imageData, forKey: "image")
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        visitedlists.append(visitedlist)
        }
    }
}
