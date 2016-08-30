//
//  AddNewconsumption  AddNewItemOfExpenditureViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class AddNewArticleViewController: UIViewController
{

    var managedContext: NSManagedObjectContext!
    var article: Article!
    var group:   ArticleGroup?
    
    var editMode: ElementPresentationMode = .ElementNewMode
    
    @IBOutlet weak var headerLabel:         UILabel!
    @IBOutlet weak var nameTextField:       UITextField!
    @IBOutlet weak var useQuantityAndPrice: UISwitch!
    @IBOutlet weak var parentButton:        UIButton!
    
    @IBAction func AddNew(sender: UIButton) {
        
        if editMode == .ElementNewMode
        {
            article = Article(Name: nameTextField.text!)
        }
        else
        {
            article.name = nameTextField.text
        }
        
        if let group = group
        {
            article.group = group
        }
        
        try! DataManager.sharedInstance().saveContext()
        
        try! managedContext.save()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addGroup(sender: UIButton) {
        
        let popController = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        popController.elementType = .ElementArticleGroupType
        
        presentViewController(popController, animated: true, completion: nil)        
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let article = article
        {
            headerLabel.text = "Edit"
            nameTextField.text        = article.name
            
            if let group = article.group
            {
                parentButton.setTitle(group.name, forState: .Normal)
            }           
            
        }
                
        nameTextField.becomeFirstResponder()
    }

}
