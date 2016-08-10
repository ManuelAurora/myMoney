//
//  PopUpViewController.swift
//  myMoney
//
//  Created by Мануэль on 05.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController
{
    var article:     Article?
    var tableString: TableString?
    var accountView: NewAccountView?
    
    var mode: Mode = .New
    var type: Type = .Expense
       
    
    @IBOutlet weak var popUpViewExpense: UIView!
    @IBOutlet weak var addButton:        UIButton!
    @IBOutlet weak var closeButton:      UIButton!
    
    @IBAction func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                  
        view.backgroundColor = UIColor.clearColor()
        
        switch type
        {
            
        case .Expense:
            
            showArticleView()
            
        case .Account:
            
            showAccountView()
            
        case .AccountList:
            
            chooseAccountView()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PopUpViewController: UIViewControllerTransitioningDelegate
{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimationController()
    }
    
}

