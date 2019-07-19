//
//  UserInputViewController.swift
//  foodies_finalproject
//
//  Created by 韩嘉燕 on 4/23/19.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
import CoreData

var image: UIImage = UIImage(named:"nophoto")!

class UserInputViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputCuisine: UITextField!
    @IBOutlet weak var inputReview: UITextView!
    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var name = [String]()
    var cuisine = [String]()
    var review = [String]()
    var rating = [String]()
    var trimmedName = String()
    var trimmedCuisine = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        // Do any additional setup after loading the view.
        inputName.text = placeholdertext
        inputName.delegate = self
        inputCuisine.delegate = self
        inputReview.delegate = self
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textName: UITextField) -> Bool {
        // Hide the keyboard
        inputName.resignFirstResponder()
        inputCuisine.resignFirstResponder()
        inputReview.resignFirstResponder()
        return true
    }

    @IBAction func save(_ sender: UIButton){
        //gets rid of whitespaces
        trimmedName = (inputName.text?.trimmingCharacters(in: .whitespaces))!
        trimmedCuisine = (inputCuisine.text?.trimmingCharacters(in: .whitespaces))!
        
        //checks that user inputs aren't empty
        if (trimmedName.isEmpty || trimmedCuisine.isEmpty) {
            //doesn't save when one or both textfields are empty/whitespaces
        } else { //saves input values to Core Data
            let name = inputName.text
            let cuisine = inputCuisine.text
            let review = inputReview.text
            let rating = ratingControl.rating
            let Image = image
            addReview(name: name!, cuisine: cuisine!, review: review!,image: Image, rating:rating)
        }

    }
    
    @IBDesignable class RoundButton: UIButton {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            sharedInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            sharedInit()
        }
        
        override func prepareForInterfaceBuilder() {
            sharedInit()
        }
        
        func sharedInit() {
            // Common logic goes here
        }
        
        func refreshCorners(value: CGFloat) {
            layer.cornerRadius = value
        }
        
        
    }
    
    @IBAction func upload(_ sender: UIButton){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            //
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        inputImage.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addReview(name: String, cuisine: String, review: String, image: UIImage, rating:Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Restaurants", in: managedContext)
        
        let restaurant = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        restaurant.setValue(name, forKey: "name")
        restaurant.setValue(cuisine, forKey: "cuisine")
        restaurant.setValue(review, forKey: "review")
        restaurant.setValue(String(rating), forKey: "rating")
        
        //Use image name from bundle to create NSData
        //Now use image to create into NSData format
        let imageData:NSData = image.pngData()! as NSData
        restaurant.setValue(imageData, forKey: "image")
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unable to save \(nserror), \(nserror.userInfo)")
            abort()
        }
        restaurants.append(restaurant)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
