//
//  ViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class CheckViewController: CoreDataTableViewController
{
    var managedContext: NSManagedObjectContext!
  
    var groupFilterPredicate: NSPredicate? = nil
    
    var filterView: GroupFilterView?
    
    var articleCatalog: [Article] {
        
        if let predicate = groupFilterPredicate
        {
            return AllCatalogs.sharedInstance().catalogArticle.objectsFiltered(by: predicate) as! [Article]
        }
        else
        {
            return AllCatalogs.sharedInstance().catalogArticle.allObjects() as! [Article]
        }        
    }
    
    var check: Registrator?
  
    var presentationMode: DocumentPresentationMode = .documentNewMode
    
    var totalExpense: Double = 0
    
    @IBOutlet weak var productView:   UICollectionView!
    @IBOutlet weak var date:          UILabel!
    @IBOutlet weak var AddEditButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var groupScrollView: UIScrollView!
    
    @IBAction func chooseAccount(_ sender: AnyObject) {
        
        chooseAccount()
    }
        
    @IBAction func Cancel() {
    
        cancel()
    }
    
    @IBAction func record() {
   
        saveExpense()
    }
    
    func filterArticles(_ sender: UIButton) {
        
        guard let button = sender as? GroupFilterView else { return }
        
        if button.selectedAsFilter == true
        {
            button.selectedAsFilter = false
            
            groupFilterPredicate = nil
            
            filterView = nil
        }
        else
        {
            groupFilterPredicate = NSPredicate(format: "group.name=%@", button.nameLabel.text!)
            
            button.selectedAsFilter = true
            
            if let filterView = filterView
            {
                filterView.selectedAsFilter = false
            }
            
            filterView = button
        }
        
        productView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibs()
        
        layoutGroupFilters()       
        
        makeCustomLayout()
        
        prepareDocumentPresentation()
        
        fetchData()
    }
    
    func makeCustomLayout() {
        layoutCollectionView()
    }
}

