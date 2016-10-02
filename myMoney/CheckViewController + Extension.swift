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
    func itemSelected(atIndexPath index: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        let article = articleCatalog[(index as NSIndexPath).row]
        
        controller.article = article
        
        controller.elementPresentationMode = .elementNewMode
        controller.elementType             = .elementArticleType
        
        present(controller, animated: true, completion: nil)
    }
    
    func fetchData() {
        
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        
        let predicate = NSPredicate(format: "tablePart.expenditure = %@", check!)
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
      
        fetchRequest = NSFetchRequest(entityName: "TableString")
        
        
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try fetchedResultsController?.performFetch()
            
        }
        catch let error as NSError
        {
            
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func prepareDocumentPresentation() {
        
        switch presentationMode
        {
        case .documentEditMode:
            AddEditButton.setTitle("Save", for: UIControlState())
            date.text   = String(describing: check!.date)
            
        case .documentNewMode:
            
            check = Expenditure()
            
            AddEditButton.setTitle("Add", for: UIControlState())
        }
        
        date.text = prettyStringFrom(check!.date)
        
        if let account = check?.account
        {
            accountButton.setTitle(account.name, for: UIControlState())
        }
        else
        {
            let mainAcc = Account.mainAccount()
            
            accountButton.setTitle("\(mainAcc.name)", for: UIControlState())
            
            check?.account = mainAcc
        }
    }    
    
    func layoutGroupFilters() {
        
        groupScrollView.removeConstraints(groupScrollView.constraints)
        groupScrollView.translatesAutoresizingMaskIntoConstraints = true
        
        let padding: CGFloat = 5
        var itemIndex: CGFloat = 0
        
        groupScrollView.frame.size = CGSize(width: view.bounds.width, height: 50)
        groupScrollView.contentSize.width = view.frame.width * 10
        
        for group in AllCatalogs.sharedInstance().catalogArticleGroups.allObjects() as! [ArticleGroup]
        {
            let gView = GroupFilterView.loadFromNib()
            
            gView.frame = CGRect(x: itemIndex * (gView.bounds.width + padding), y: gView.frame.origin.y, width: gView.bounds.width, height: gView.bounds.height)
            
            gView.addTarget(self, action: #selector(CheckViewController.filterArticles(_:)), for: .touchUpInside)
            
            gView.nameLabel.text = group.name
            
            groupScrollView.addSubview(gView)
            
            itemIndex += 1
        }
    }
    
    func registerNibs() {
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        productView.register(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
    
    //Save operation
    func saveExpense() {
        guard let check = check else { return }
        
        switch presentationMode
        {
        case .documentEditMode:
            
            check.deleteOldRegisterLine()
            check.conduct()
            
        case .documentNewMode:
            
            check.conduct()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Cancel operation
    func cancel() {
        dismiss(animated: true, completion: nil)
        managedContext.rollback()
    }
    
    //Account choosing
    func chooseAccount() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        controller.elementType = .elementAccountListType
        
        present(controller, animated: true, completion: nil)
    }
    
    //Renumerates table view cells 
    func renumerateStrings() {
        
        var number = 1
        
        for string in fetchedResultsController?.fetchedObjects as! [TableString]
        {
            if !string.isDeleted
            {
                string.number = number as NSNumber?
                number += 1
            }
        }
    }
    
    //Makes custom layout for collection view
    func layoutCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        
        productView.backgroundColor = UIColor.brown
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 4, right: 4)
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing      = 14
        
        let size = floor(productView.superview!.bounds.width / 6)
        
        layout.itemSize = CGSize(width: size, height: size)
        
        productView.collectionViewLayout = layout
    }
}

// MARK: >> EXT - UICollectionViewDelegate
extension CheckViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        itemSelected(atIndexPath: indexPath)
    }
}

// MARK: >> EXT - UICollectionViewDataSource
extension CheckViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        let article = articleCatalog[(indexPath as NSIndexPath).row]
        
        cell.articleNameLabel.text = article.name
        
        if let imageData = article.image
        {
            cell.articleImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleCatalog.count
    }
}

// MARK: >> EXT - UITableViewDelegate & DataSource
extension CheckViewController
{        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCellTableViewCell
        
        let articleString = fetchedResultsController?.object(at: indexPath) as! TableString
        
        cell.name.text  = articleString.article!.name
        cell.price.text = String(articleString.price!.floatValue) 
        cell.number.text = String((indexPath as NSIndexPath).row + 1)
        
        totalExpense += articleString.price!.doubleValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        let tableString = fetchedResultsController?.object(at: indexPath) as! TableString
        
        let article = tableString.article
        
        controller.elementPresentationMode = .elementEditMode
        controller.elementType             = .elementArticleType
        
        controller.article     = article
        controller.tableString = tableString
        
        present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let articleString = fetchedResultsController?.object(at: indexPath) as! TableString
        
        managedContext.delete(articleString)
        
        renumerateStrings()
    }
}

// MARK: >> EXT - UITapGestureRecognizer
extension CheckViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {        
        
        return true
    }
    
    
}


