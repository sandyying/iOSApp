//
//  ViewController.swift
//  foodies_finalproject
//
//  Created by 应芮 on 2019/4/17.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
import AVFoundation

class LandingPageViewController: UIViewController {
    @IBOutlet weak var click: UIView!
    @IBOutlet weak var seachButtonView:UIView!
    @IBOutlet weak var restaurantButtonView:UIView!
    @IBOutlet weak var userInputButtonView:UIView!
    @IBOutlet weak var welcomeSlogan: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var SavedList: UIButton!
    
    var intro: AVAudioPlayer? = nil
    
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
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.intro = self.loadSound(filename: "click_2")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func fadeIn(sender: UIButton) {
        //play sound
        self.intro?.play()
        
        UIView.animate(withDuration: 1.5, animations: {
            self.SavedList.alpha = 1.0
            self.heart.alpha = 1.0
            self.seachButtonView.alpha = 1.0
            self.restaurantButtonView.alpha = 1.0
            self.userInputButtonView.alpha = 1.0
            self.logo.alpha = 1.0
            self.click.alpha = 0.0
            self.welcomeSlogan.alpha = 0.0
            self.seachButtonView.frame.origin.y -= 175
            self.restaurantButtonView.frame.origin.y -= 175
            self.userInputButtonView.frame.origin.y -= 175
            self.logo.frame.origin.y -= 50
        
            ;
            
            
        }
        )
    }
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        if segue.identifier == "homeReview" {
            placeholdertext = ""
        }
    }
    
    @IBAction func SearchViewTransition(_ sender: Any) {
        
    }
    
    
    @IBAction func unwindFromView(_sender: UIStoryboardSegue){
        
    }

}
