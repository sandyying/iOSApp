//
//  UserInputViewController.swift
//  foodies_finalproject
//
//  Created by Lillian Lee on 4/17/19.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
var result: String = ""
class SearchRestaurant{
    
    // initialize variables
    var _name: String = ""
    var _address : String = ""
    var _votes : String = ""
    var _avgcost : String = ""
    var _rating : String = ""
    var _potrait : String = ""
    var _phone :String = ""
    var _closed: Bool = false
    var _lat: Double = 0.0
    var _long: Double = 0.0
    // create get and set method
    var name: String {
        get { return _name}
        set (newName) { _name = newName }
    }
    //name, profession, level, current and total hit points, attack power multiplier, and a portrait
    
    var address: String {
        get { return _address}
        set (newaddress) { _address = newaddress }
    }
    
    var votes: String {
        get { return _votes}
        set (newVotes) { _votes = newVotes}
    }
    
    var avgcost: String {
        get { return _avgcost}
        set (newAvgcosts) { _avgcost = newAvgcosts}
    }
    
    var rating: String {
        get { return _rating}
        set (newRatings) { _rating = newRatings}
    }
    
    
    
    var potrait: String {
        get { return _potrait}
        set (newPotrait) { _potrait = newPotrait}
    }
    
    var phone: String {
        get { return _phone}
        set (newPhone) { _phone = newPhone}
    }
    
    var closed: Bool {
        get {return _closed}
        set (newClosed) { _closed = newClosed}
    }
    
    var lat: Double {
        get { return _lat}
        set (newLat) { _lat = newLat}
    }
    
    var long: Double {
        get { return _long}
        set (newLong) { _long = newLong}
    }
    
    
    init(name: String, address: String,  votes: String, avgcost:String, rating:String, potrait: String, phone: String, closed: Bool,lat:Double,long:Double ) {
        self.name = name
        self.avgcost = avgcost
        self.votes = votes
        self.address = address
        self.rating = rating
        self.potrait = potrait
        self.phone = phone
        self.closed = closed
        self.long = long
        self.lat = lat
        
        
    }
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RestaurantDataProtocol, UITextFieldDelegate {
    
    
    var dataSession = RestaurantData()
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var SearchSubmit: UIButton!
    @IBOutlet weak var SearchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.dataSession.delegate = self
        location.delegate = self
        cuisine.delegate = self
        message.delegate = self
        
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        SearchSubmit.layer.cornerRadius = 4
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textName: UITextField) -> Bool {
        // Hide the keyboard
        location.resignFirstResponder()
        cuisine.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func textFieldDidEndEditing(_ textField: UITextField)-> String{
        return textField.text!
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        var searchlocation = textFieldDidEndEditing(location)
        var searchcuisine = textFieldDidEndEditing(cuisine)
        if searchlocation != "" && searchcuisine != ""
        {
            searchlocation = searchlocation.replacingOccurrences(of: " ", with: "+")
            searchcuisine = searchcuisine.replacingOccurrences(of: " ", with: "+")
            result = "location=" + searchlocation + "&term=" + searchcuisine
            let entry:Int = 10
            self.dataSession.getData(exampleDataNumber: String(entry))
        }
        //SearchRestaurants = [SearchRestaurant(name: "China Family",  address: "Austin", votes: "20", avgcost: "$10", rating: "5/5", potrait: "food1")]
        //self.SearchTableView.reloadData()
    }
    
    
    var SearchRestaurants = [SearchRestaurant]()
    func responseDataHandler(data:NSDictionary) {
        SearchRestaurants = [SearchRestaurant]()
        let finalresult = data.value(forKeyPath:"businesses") as? NSArray
        
        for i in finalresult!{
            let Resdict: NSDictionary = i as! NSDictionary
            let name:String = Resdict["name"] as! String
            let StringUserRating: Float = Resdict["rating"] as! Float
            let address:NSDictionary = (i as AnyObject).value(forKeyPath: "location") as! NSDictionary
            let ArrayAddress = (address as AnyObject).value(forKeyPath: "display_address") as! NSArray
            var StringAddress = ""
            for i in ArrayAddress{
                StringAddress += (i as! String + " ")
            }
            let avgcost = Resdict["price"] as? String ?? "N/A"
            let potrait = Resdict["image_url"] as! String
            let votes:Int = Resdict["review_count"] as! Int
            let phone = Resdict["display_phone"] as! String
            //is closed = is business closed or not, not open hours
            let is_closed = Resdict["is_closed"] as! Bool
            let cord:NSDictionary = (i as AnyObject).value(forKeyPath: "coordinates") as! NSDictionary
            print(cord)
            let lat = cord["latitude"] as! Double
            
            print(lat)
            let long = cord["longitude"] as! Double
            print(long)
            /*// open hours
            let open: NSMutableArray? = Resdict.object(forKey: "hours") as? NSMutableArray
            print(open)*/
            SearchRestaurants.append(SearchRestaurant(name: name,  address: StringAddress, votes: String(votes), avgcost: String(avgcost), rating: String(StringUserRating), potrait: potrait, phone: phone, closed: is_closed,lat:lat, long:long))
        }
        //Run this handling on a separate thread
        DispatchQueue.main.async() {
        self.SearchTableView.reloadData()
        }
    }
    
    func responseError(message:String) {
        //Run this handling on a separate thread
        DispatchQueue.main.async() {
            self.message.text = message
            
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return SearchRestaurants.count //input.count
    }
    
   
    
    
//    var Num = -1
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Num = indexPath.row
        let cellIdentifier = "SearchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchCell
        
        let restaurants = SearchRestaurants[indexPath.row]
       
        cell.name.text = restaurants.name
        let url = NSURL(string:restaurants.potrait)
        let data = NSData(contentsOf:url! as URL)
        if data == nil{
            cell.portrait.image = UIImage(named:"nophoto")
        }
        else{
            cell.portrait.image = UIImage(data:data! as Data)
        }
        let Searchrating = Float(restaurants.rating) ?? 0
        cell.SearchRating.rating = Int(round(Searchrating))
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexPath = tableView.indexPathForSelectedRow!
//        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
//        //let index = tableView.indexPathForSelectedRow?.row
//        Num = indexPath.row
//    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        if segue.identifier == "SendDataSegue" {
            let index = SearchTableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! RestaurantDetailViewController
            vc.PassedName = SearchRestaurants[index!].name
            vc.PassedRating = SearchRestaurants[index!].rating
            let url = NSURL(string:SearchRestaurants[index!].potrait)
            let data = NSData(contentsOf:url! as URL)
            if data == nil{
                vc.PassedPotrait = UIImage(named:"nophoto")!
            }
            else{
                vc.PassedPotrait = UIImage(data:data! as Data)!
            }
            vc.PassedLong = SearchRestaurants[index!].long
            vc.PassedLat = SearchRestaurants[index!].lat
            vc.PassedAddress = SearchRestaurants[index!].address
            vc.PassedCost = SearchRestaurants[index!].avgcost
            vc.PassedVotes = SearchRestaurants[index!].votes
            vc.PassedPhone = SearchRestaurants[index!].phone
            vc.PassedClosed = SearchRestaurants[index!].closed
        }
    }
    
}

