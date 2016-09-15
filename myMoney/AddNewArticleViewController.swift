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
    
    var editMode: ElementPresentationMode = .elementNewMode
    
    @IBOutlet weak var headerLabel:         UILabel!
    @IBOutlet weak var nameTextField:       UITextField!
    @IBOutlet weak var useQuantityAndPrice: UISwitch!
    @IBOutlet weak var parentButton:        UIButton!
    @IBOutlet weak var articleImageView:    UIImageView!
    
    @IBAction func save(_ sender: UIButton) {
        
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
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGroup(_ sender: UIButton) {
        
        let popController = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        popController.elementType = .elementArticleGroupType
        
        present(popController, animated: true, completion: nil)        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        managedContext.rollback()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch editMode
        {
        case .elementNewMode:
            article = Article(named: nameTextField.text!)
            
        case .elementEditMode:
            
            headerLabel.text   = "Edit"
            nameTextField.text = article.name
            
            if let group = article.group
            {
                parentButton.setTitle(group.name, for: UIControlState())
            }
        }        
                
        nameTextField.becomeFirstResponder()
    }

}
