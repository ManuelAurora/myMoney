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
    
    var editMode: ElementPresentationMode = .elementNewMode
    
    @IBOutlet weak var headerLabel:    UILabel!
    @IBOutlet weak var nameTextField:  UITextField!
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBAction func save(_ sender: UIButton) {
        
        switch editMode
        {
        case .elementNewMode:
            group = ArticleGroup(withName: nameTextField.text!)
        
        case .elementEditMode:
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
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addParent(_ sender: UIButton) {
        
        let popController = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        popController.elementType = .elementArticleGroupType
        
        present(popController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let group = group
        {
            headerLabel.text   = "Edit"
            nameTextField.text = group.name
            
            if let image = group.image
            {
                groupImageView.image = UIImage(data: image as Data)
            }
        }
        
        nameTextField.becomeFirstResponder()
    }
    
}
