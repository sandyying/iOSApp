//
//  RestaurantsViewController.swift
//  foodies_finalproject
//
//  Created by Lillian Lee on 4/22/19.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
import CoreData

var restaurants = [NSManagedObject]()

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableVw: UITableView!
    var name = [String]()
    var cuisine = [String]()
    var review = [String]()
    var portrait = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVw.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*//Set up search
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reviews"
        navigationItem.searchController = searchController
        definesPresentationContext = true*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRestaurants()
        tableVw.reloadData()
    }
    
    func getRestaurants(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Restaurants")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            restaurants = results
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        //if isFiltering(){
            //searchBar.setIsFilteringToShow(filteredItemCount: filteredReviews.count, of places.count)
        //}
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantsTableViewCell
        
        let restaurant = restaurants[indexPath.row]
        
        let name = restaurant.value(forKey: "name") as! String
        cell.name.text = name
        let cuisine = restaurant.value(forKey: "cuisine") as! String
        cell.cuisine.text = "Cuisine: " + cuisine
        let review: String = restaurant.value(forKey: "review") as! String
        cell.review.text = String(review)
        cell.portrait.image = UIImage(data: ((restaurant.value(forKey: "image") as! NSData) as Data))
        let rating = restaurant.value(forKey: "rating") as! String
        cell.UserInputRating.rating = Int(rating) ?? 0
    
        return cell
    }
    
    // Sorting
    /*func sortTable() {
        nameArray.sort() {$0.restName > $1.restName}
    }*/
    
}
