//
//  FadeOutAnimationController.swift
//  iFoundIt
//
//  Created by Мануэль on 05.05.16.
//  Copyright © 2016 Мануэль. All rights reserved.
//

import UIKit


class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 
            fromView.alpha = 0
            }, completion: { finished in
                transitionContext.completeTransition(finished)
        }) 
    }
}
