//
//  AddNewGroupViewController.swift
//  myMoney
//
//  Created by Мануэль on 02.09.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//


import UIKit
import CoreData

class AddNewGroupViewController: UIViewController
{
    
    var managedContext: NSManagedObjectContext!
    
    var group:   ArticleGroup!
    
    var editMode: ElementPresentationMode = .ElementNewMode
    
    @IBOutlet weak var headerLabel:    UILabel!
    @IBOutlet weak var nameTextField:  UITextField!
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBAction func save(sender: UIButton) {
        
        switch editMode
        {
        case .ElementNewMode:
            group = ArticleGroup(withName: nameTextField.text!)
        
        case .ElementEditMode:
            group.name = nameTextField.text!            
        }
        
        if let image = groupImageView.image
        {
            group.image = UIImagePNGRepresentation(image)
        }
        
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
    
    @IBAction func addParent(sender: UIButton) {
        
        let popController = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        popController.elementType = .ElementArticleGroupType
        
        presentViewController(popController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let group = group
        {
            headerLabel.text   = "Edit"
            nameTextField.text = group.name
            
            if let image = group.image
            {
                groupImageView.image = UIImage(data: image)
            }
        }
        
        nameTextField.becomeFirstResponder()
    }
    
}
