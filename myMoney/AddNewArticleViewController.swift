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
    @IBOutlet weak var articleImageView:    UIImageView!
    
    @IBAction func save(sender: UIButton) {
        
        if let group = group
        {
            article.group = group
        }
        
        article.name = nameTextField.text!
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addGroup(sender: UIButton) {
        
        let popController = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        popController.elementType = .ElementArticleGroupType
        
        presentViewController(popController, animated: true, completion: nil)        
    }
    
    @IBAction func cancel(sender: UIButton) {
        
        managedContext.rollback()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch editMode
        {
        case .ElementNewMode:
            article = Article(named: nameTextField.text!)
            
        case .ElementEditMode:
            
            headerLabel.text   = "Edit"
            nameTextField.text = article.name
            
            if let group = article.group
            {
                parentButton.setTitle(group.name, forState: .Normal)
            }
        }        
                
        nameTextField.becomeFirstResponder()
    }

}
