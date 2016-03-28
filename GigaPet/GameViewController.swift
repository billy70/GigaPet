//
//  GameViewController.swift
//  GigaPet
//
//  Created by William L. Marr III on 3/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var minerImage: PetImage!
    @IBOutlet weak var ratImage: PetImage!
    
    @IBOutlet weak var heartImage: DraggableImage!
    @IBOutlet weak var whipImage: DraggableImage!
    @IBOutlet weak var foodImage: DraggableImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxWhip: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var petSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {

            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxWhip = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("whip", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxWhip.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()

        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        if petSelected == "miner" {
            
            minerImage.playIdleAnimation(forSelectedPet: petSelected)
            
            // Remove the rat image.
            if let viewWithTag = self.view.viewWithTag(200) {
                viewWithTag.removeFromSuperview()
            }
        }
        
        if petSelected == "rat" {
            
            ratImage.playIdleAnimation(forSelectedPet: petSelected)
            
            // Remove the miner image.
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

