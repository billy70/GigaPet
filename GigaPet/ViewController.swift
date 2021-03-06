//
//  ViewController.swift
//  GigaPet
//
//  Created by William L. Marr III on 3/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//
//
// Credit/attribution for the audio file named whip_crack.wave:
//
//      Link: http://freesound.org/people/CGEffex/sounds/93100/
//      Author: CGEffex
//      License: CC (Creative Commons) http://creativecommons.org/licenses/by/3.0/legalcode
//
// Credit/attribution for the image of the whip:
//
//      Link: http://maugh.deviantart.com/art/Weapon-Diagram-2-221200700
//      Author: maugh
//      License: CC (Creative Commons) http://creativecommons.org/licenses/by/3.0/legalcode

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var minerImage: PetImage!
    @IBOutlet weak var ratImage: PetImage!
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1  // loop indefinitely until stopped
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        minerImage.playIdleAnimation(.Miner)
        ratImage.playIdleAnimation(.Rat)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectMiner" {
            let gvc = segue.destinationViewController as! GameViewController
            gvc.petSelected = .Miner
        } else if segue.identifier == "selectRat" {
            let gvc = segue.destinationViewController as! GameViewController
            gvc.petSelected = .Rat
        }
    }

}

