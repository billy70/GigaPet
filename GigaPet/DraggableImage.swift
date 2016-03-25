//
//  DraggableImage.swift
//  GigaPet
//
//  Created by William L. Marr III on 3/25/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import UIKit

class DraggableImage: UIImageView {
    
    // Declare a type property for the notification post ID
    // so that the game view controller can use it for the
    // observer (this way, there is no chance of misspelling it).
    static let NOTIFICATION_POST_DROP_ID = "onTargetDropped"
    
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview)
            
            if CGRectContainsPoint(target.frame, position) {
                // If the target of the "drop" is positioned on the dropTarget,
                // then post a notification to the default Notification Center.
                //
                // The game view controller GameViewController will be setup to
                // be an observer for this particular message ID, and will call
                // the method itemDroppedOnCharacter() to handle the notification.
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: DraggableImage.NOTIFICATION_POST_DROP_ID, object: nil))
            }
        }
        
        self.center = originalPosition
    }
}

