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
    
    var article:             Article!
    var indexOfStringToEdit: NSIndexPath?
    
    var mode: Mode = .New
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articlePriceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addItem() {
        
        let controller = presentingViewController as! CheckViewController
        
        let priceString = articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
        
        if mode == .New {
            
            let articleString = ArticleString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
            
            articleString.number = controller.fetchedResultsController!.sections![0].numberOfObjects + 1
            
            controller.renumerateStrings()
            
        } else {
            
            let stringToEdit = controller.fetchedResultsController!.objectAtIndexPath(indexOfStringToEdit!) as! ArticleString
            
            stringToEdit.price = Float(articlePriceTextField.text!)
        }
              
        dismissViewControllerAnimated(true, completion:nil)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articlePriceTextField.becomeFirstResponder()
        
        view.backgroundColor = UIColor.clearColor()
        
        popUpView.layer.cornerRadius = 10
        
       
        articleNameLabel.text! = article!.name!        
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
