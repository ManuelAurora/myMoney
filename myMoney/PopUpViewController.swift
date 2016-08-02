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
    
    var article:      Article?
    var incomeString: TableString?
        
    var mode:    Mode    = .New
    var docType: DocType = .Expense
    
    @IBOutlet weak var incomeNameTextField: UITextField!
    @IBOutlet weak var popUpViewExpense: UIView!
    @IBOutlet weak var popUpViewIncome: UIView!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articlePriceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addItem() {
       
        addNewOrEditItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        if docType == .Expense
        {
            articlePriceTextField.becomeFirstResponder()
            
            popUpViewIncome.hidden = true
            articleNameLabel.text! = article!.name!
            
        }
        else
        {
            incomeNameTextField.becomeFirstResponder()
            popUpViewExpense.hidden  = true
        }
        
        popUpViewIncome.layer.cornerRadius  = 10
        popUpViewExpense.layer.cornerRadius = 10
       
        
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
