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
    @IBOutlet weak var parentButton:   UIButton!
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBAction func save(sender: UIButton) {
        
        if editMode == .ElementNewMode
        {
            let group   = ArticleGroup(withName: nameTextField.text!)
            let article = Article(named: group.name)
            
            article.basedOnGroup = true
            article.group        = group
            
            if let image = groupImageView.image
            {
                article.image = UIImagePNGRepresentation(image)
            }
        }
        else
        {
            group.name = nameTextField.text!
            
            if let image = groupImageView.image
            {
                group.articleBasedOnGroup.image = UIImagePNGRepresentation(image)
            }
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
            
            if let parent = group.parent
            {
                parentButton.setTitle(parent.name, forState: .Normal)
            }
            
            if let image = group.articleBasedOnGroup.image
            {
                groupImageView.image = UIImage(data: image)
            }
        }
        
        nameTextField.becomeFirstResponder()
    }
    
}
