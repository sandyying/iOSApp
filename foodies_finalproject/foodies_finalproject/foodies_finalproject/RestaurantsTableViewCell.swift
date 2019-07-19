//
//  RestaurantsTableViewCell.swift
//  foodies_finalproject
//
//  Created by Lillian Lee on 4/22/19.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit

class RestaurantsTableViewCell: UITableViewCell{
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var UserInputRating: RatingControl!
}
