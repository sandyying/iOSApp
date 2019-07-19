//
//  Query.swift
//  foodies_finalproject
//
//  Created by 应芮 on 2019/4/22.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
protocol RestaurantDataProtocol
{
    func responseDataHandler(data:NSDictionary)
    func responseError(message:String)
}

class RestaurantData {
    
    private let urlSession = URLSession.shared
    private let urlPathBase = "https://api.yelp.com/v3/businesses/search?"
    
    private var dataTask:URLSessionDataTask? = nil
    var delegate:RestaurantDataProtocol? = nil
    init() {}
    
    func getData(exampleDataNumber:String) {
        var items = [String]()
        var urlPath = self.urlPathBase + result
        let url:NSURL? = NSURL(string: urlPath)
        var request = URLRequest(url: url! as URL)
        let apikey = "nDGNZ_B203sQcgI9dl1HNWDrkbpSEGKYdDvt5CX9_ZMPFgldRNwfkMiERsejsz50B_MmmHiLZQnmb9C7lixgZzZ-YAsAv66zhGC3CFd_j-XgIDhl-z8KAqkOLLrAXHYx"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let dataTask = self.urlSession.dataTask(with: request) { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
            } else {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    if jsonResult != nil {
                        
                        let finalresult = jsonResult?.value(forKeyPath:"businesses") as? NSArray
                        
                        if finalresult != nil{
                            self.delegate?.responseDataHandler(data: jsonResult!)
                           
                        }
                        else{
                            self.delegate?.responseError(message: "Restaurant not found")
                        }
                    }
                        
                    else{
                        self.delegate?.responseError(message: "Restaurant not found")
                    }
                    
                    
                    
                } catch {
                    //Catch and handle the exception
                }
            }
        }
        dataTask.resume()
    }
}



