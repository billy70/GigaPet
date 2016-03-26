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

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

