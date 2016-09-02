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
    var checkNumber:    Int!
    var articleCatalog: Catalog!
    
    var check: Registrator?
  
    var presentationMode: DocumentPresentationMode = .DocumentNewMode
    
    var totalExpense: Double = 0
    
    @IBOutlet weak var productView:   UICollectionView!
    @IBOutlet weak var date:          UILabel!
    @IBOutlet weak var AddEditButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    @IBAction func chooseAccount(sender: AnyObject) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.elementType = .ElementAccountListType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addNewArticle() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewArticle") as! AddNewArticleViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func Cancel() {
    
        dismissViewControllerAnimated(true, completion: nil)
        managedContext.rollback()
    }
    
    @IBAction func record() {
   
        guard let check = check else { return }
        
        switch presentationMode
        {
        case .DocumentEditMode:
            
            check.deleteOldRegisterLine()
            check.conduct()
            
        case .DocumentNewMode:
            
            check.conduct()
        }        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        
        productView.registerNib(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        
        makeCustomLayout()
        
        switch presentationMode
        {
        case .DocumentEditMode:
            AddEditButton.setTitle("Save", forState: .Normal)
            date.text   = String(check!.date)
            
        case .DocumentNewMode:
            
            check = Expenditure(Number: checkNumber)
            
            AddEditButton.setTitle("Add", forState: .Normal)
        }
        
        date.text = prettyStringFrom(check!.date)
        
        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let account = check?.account
        {
            accountButton.setTitle(account.name, forState: .Normal)
        }
        else
        {
            let mainAcc = Account.mainAccount()
            
            accountButton.setTitle("\(mainAcc.name)", forState: .Normal)
            
            check?.account = mainAcc
        }
    }
    
    func itemSelected(atIndexPath index: NSIndexPath) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let article = articleCatalog.allObjects()[index.row] as! Article
        
        controller.article = article
        
        controller.elementPresentationMode = .ElementNewMode
        controller.elementType             = .ElementArticleType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func fetchData() {
        
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        
        let predicate = NSPredicate(format: "tablePart.expenditure = %@", check!)
        
        let fetchRequest = NSFetchRequest(entityName: "TableString")
        
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try fetchedResultsController?.performFetch()
            
        } catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func renumerateStrings() {
        
        var number = 1
        
        for string in fetchedResultsController!.fetchedObjects! as! [TableString]
        {
            if !string.deleted {
                string.number = number
                number += 1
            }
        }
    }
    
    func makeCustomLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        productView.backgroundColor = UIColor.whiteColor()
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing      = 14
        
        let size = floor(productView.bounds.width / 4)
        
        layout.itemSize = CGSize(width: size, height: size)
        
        productView.collectionViewLayout = layout
    }
}

extension CheckViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = fetchedResultsController!.sections![section]
        
        return section.objects!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell") as! ArticleCellTableViewCell
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        cell.name.text  = articleString.article!.name
        cell.price.text = String(articleString.price!.floatValue) ?? ""
        cell.number.text = String(indexPath.row + 1)
        
        totalExpense += articleString.price!.doubleValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let tableString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        let article = tableString.article
        
        controller.elementPresentationMode = .ElementEditMode
        controller.elementType             = .ElementArticleType
        
        controller.article     = article
        controller.tableString = tableString
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        managedContext.deleteObject(articleString)
        
        renumerateStrings()
    }
}

extension CheckViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        itemSelected(atIndexPath: indexPath)
    }
}

extension CheckViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = productView.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        let article = articleCatalog.allObjects()[indexPath.row] as! Article
        cell.articleNameLabel.text = article.name
               
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleCatalog.allObjects().count
    }
    
    
}


