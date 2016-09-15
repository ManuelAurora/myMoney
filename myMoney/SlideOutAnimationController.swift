//
//  SlideOutAnimationController.swift
//  iFoundIt
//
//  Created by Мануэль on 04.05.16.
//  Copyright © 2016 Мануэль. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { return 0.3 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        let containerView = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations:
            {
                fromView.center.y -= containerView.bounds.height
                fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion:
            { finished in
                
                transitionContext.completeTransition(finished)
        })
    }    
}

