//
//  GameViewController.swift
//  GigaPet
//
//  Created by William L. Marr III on 3/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import AVFoundation

let HEART_ITEM: UInt32 = 0
let WHIP_ITEM: UInt32 = 1
let FOOD_ITEM: UInt32 = 2

class GameViewController: UIViewController {

    @IBOutlet weak var minerImage: PetImage!
    @IBOutlet weak var ratImage: PetImage!
    
    @IBOutlet weak var heartImage: DraggableImage!
    @IBOutlet weak var whipImage: DraggableImage!
    @IBOutlet weak var foodImage: DraggableImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    @IBOutlet weak var restartButton: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxWhip: AVAudioPlayer!
    var sfxMinerDeath: AVAudioPlayer!
    var sfxRatDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var petSelected: PetType = .Miner
    var petSelectedImage: PetImage!
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = HEART_ITEM


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {

            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxWhip = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("whip", ofType: "wav")!))
            try sfxMinerDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("miner_death", ofType: "wav")!))
            try sfxRatDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("rat_death", ofType: "mp3")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxWhip.prepareToPlay()
            sfxMinerDeath.prepareToPlay()
            sfxRatDeath.prepareToPlay()
            sfxSkull.prepareToPlay()

        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        if petSelected == .Miner {
            
            petSelectedImage = minerImage
            
            // Remove the rat image.
            if let viewWithTag = self.view.viewWithTag(200) {
                viewWithTag.removeFromSuperview()
            }
        }
        
        if petSelected == .Rat {
            
            petSelectedImage = ratImage
            
            // Remove the miner image.
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
        
        heartImage.dropTarget = petSelectedImage
        whipImage.dropTarget = petSelectedImage
        foodImage.dropTarget = petSelectedImage

        initializeGameState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartButtonTapped(sender: AnyObject) {
        initializeGameState()
    }
    
    func itemDroppedOnCharacter(someObj: AnyObject) {
        print(#function)
        
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        
        whipImage.alpha = DIM_ALPHA
        whipImage.userInteractionEnabled = false
        
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == HEART_ITEM {
            sfxHeart.play()
        } else if currentItem == WHIP_ITEM {
            sfxWhip.play()
        } else {
            sfxBite.play()
        }
    }
    
    func getRandomItem() -> UInt32 {
        print(#function)
        
        return arc4random_uniform(3)
    }
    
    func updateItems() {
        print(#function)
        
        if currentItem == HEART_ITEM {
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
            
            whipImage.alpha = DIM_ALPHA
            whipImage.userInteractionEnabled = false
            
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
        } else if currentItem == WHIP_ITEM {
            
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            whipImage.alpha = OPAQUE
            whipImage.userInteractionEnabled = true
            
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
        } else {
            
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            whipImage.alpha = DIM_ALPHA
            whipImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
            
        }
    }
    
    func initializeGameState() {
        print(#function)
        
        penalties = 0
        monsterHappy = false
        petSelectedImage.playIdleAnimation(petSelected)
        
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA

        currentItem = getRandomItem()
        updateItems()
        
        restartButton.enabled = false
        restartButton.hidden = true
        
        // Note here that "itemDroppedOnCharacter" is the method to be called, which accepts
        // one parameter, and "onTargetDropped" is the name of the notification.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.itemDroppedOnCharacter(_:)), name: DraggableImage.NOTIFICATION_POST_DROP_ID, object: nil)
        
        startTimer()
    }
    
    func changeGameState() {
        print(#function)
        
        if monsterHappy == false {
            
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Image.alpha = OPAQUE
            } else if penalties == 2 {
                penalty2Image.alpha = OPAQUE
            } else if penalties >= 3 {
                penalty3Image.alpha = OPAQUE
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        if penalties < MAX_PENALTIES {
            currentItem = getRandomItem()
            updateItems()
        }
        
        // You need to keep making the monster happy,
        // thus, the reset of monsterHappy to 'false' here.
        monsterHappy = false
    }
    
    func startTimer() {
        print(#function)
        
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(GameViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func gameOver() {
        print(#function)
        
        timer.invalidate()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DraggableImage.NOTIFICATION_POST_DROP_ID, object: nil)
        
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        whipImage.alpha = DIM_ALPHA
        whipImage.userInteractionEnabled = false
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        
        petSelectedImage.playDeathAnimation(petSelected)
        
        if petSelected == .Miner {
            sfxMinerDeath.play()
        } else {
            sfxRatDeath.play()
        }
        
        restartButton.hidden = false
        restartButton.enabled = true
    }
}

