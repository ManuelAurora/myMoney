//
//  CheckViewController + Extension.swift
//  myMoney
//
//  Created by Мануэль on 04.09.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

extension CheckViewController
{
    //Executed when user tap on Article in collectionView
    func itemSelected(atIndexPath index: NSIndexPath) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let article = articleCatalog[index.row]
        
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
    
    func prepareDocumentPresentation() {
        
        switch presentationMode
        {
        case .DocumentEditMode:
            AddEditButton.setTitle("Save", forState: .Normal)
            date.text   = String(check!.date)
            
        case .DocumentNewMode:
            
            check = Expenditure()
            
            AddEditButton.setTitle("Add", forState: .Normal)
        }
        
        date.text = prettyStringFrom(check!.date)
        
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
    
    func layoutGroupFilters() {
        
        groupScrollView.removeConstraints(groupScrollView.constraints)
        groupScrollView.translatesAutoresizingMaskIntoConstraints = true
        
        let padding: CGFloat = 5
        var itemIndex: CGFloat = 0
        
        groupScrollView.contentSize.width = self.view.frame.width * 10
        
        for group in AllCatalogs.sharedInstance().catalogArticleGroups.allObjects() as! [ArticleGroup]
        {
            let view = GroupFilterView.loadFromNib()
            
            view.frame = CGRect(x: itemIndex * (view.bounds.width + padding), y: view.frame.origin.y, width: view.bounds.width, height: view.bounds.height)
            
            view.addTarget(self, action: #selector(CheckViewController.filterArticles(_:)), forControlEvents: .TouchUpInside)
            
            view.nameLabel.text = group.name            
            
            groupScrollView.addSubview(view)
            
            itemIndex += 1
        }
    }
    
    func registerNibs() {
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        productView.registerNib(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
    
    //Save operation
    func saveExpense() {
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
    
    //Cancel operation
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
        managedContext.rollback()
    }
    
    //Account choosing
    func chooseAccount() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.elementType = .ElementAccountListType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    //Renumerates table view cells 
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
    
    //Makes custom layout for collection view
    func layoutCollectionView() {
        
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

// MARK: >> EXT - UICollectionViewDelegate
extension CheckViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        itemSelected(atIndexPath: indexPath)
    }
}

// MARK: >> EXT - UICollectionViewDataSource
extension CheckViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = productView.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        let article = articleCatalog[indexPath.row]
        
        cell.articleNameLabel.text = article.name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleCatalog.count
    }
}

// MARK: >> EXT - UITableViewDelegate & DataSource
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

// MARK: >> EXT - UITapGestureRecognizer
extension CheckViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {        
        
        return true
    }
    
    
}


