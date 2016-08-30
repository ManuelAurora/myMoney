//
//  ArticleManageViewController.swift
//  myMoney
//
//  Created by Мануэль on 29.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData


class ArticleManageViewController: UIViewController
{
    var updateIndexPaths   = [NSIndexPath]()
    var deleteIndexPaths   = [NSIndexPath]()
    var insertIndexPaths   = [NSIndexPath]()
    
    var collectionViewToFetch: CollectionViewToFetch?
    var entityName:            String?
    
    var managedContext: NSManagedObjectContext!
    
    var fetchedResultsController: NSFetchedResultsController {
        
        if collectionViewToFetch == .Articles
        {
            entityName = "Article"
        }
        else if collectionViewToFetch == .Groups
        {
            entityName = "ArticleGroup"
        }
        
        let fetchRequest = NSFetchRequest(entityName: entityName!)
        
        fetchRequest.sortDescriptors = []
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        return controller
    }

    @IBOutlet weak var groupsCollectionView: UICollectionView!
    
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    @IBAction func addNewArticle(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("addNewArticle") as! AddNewArticleViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addNewGroup(sender: UIButton) {
        
    }
    
    func makeCustomLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        articlesCollectionView.backgroundColor = UIColor.whiteColor()
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing      = 14
        
        let size = floor(articlesCollectionView.bounds.width / 4)
        
        layout.itemSize = CGSize(width: size, height: size)
        
        articlesCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
        
       registerNibs()
        
       makeCustomLayout()
    }
    
    private func registerNibs() {
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        
        articlesCollectionView.registerNib(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        groupsCollectionView.registerNib(nib,   forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
}

extension ArticleManageViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        switch collectionView
        {
        case articlesCollectionView:
            
            toggleCollectionView(collectionView)
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("addNewArticle") as! AddNewArticleViewController
            
            let article = fetchedResultsController.fetchedObjects![indexPath.row] as! Article
            
            controller.article        = article
            controller.editMode       = .ElementEditMode
            controller.managedContext = managedContext
            
            presentViewController(controller, animated: true, completion: nil)
            
        default:
            break
        }
        
        
    }
}

extension ArticleManageViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        toggleCollectionView(collectionView)
        
        return fetchedResultsController.fetchedObjects!.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        toggleCollectionView(collectionView)
        
        var cell = ArticleCollectionViewCell()
        
        switch collectionView
        {
        case articlesCollectionView:
            
            cell = articlesCollectionView.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
            
            let article = fetchedResultsController.fetchedObjects![indexPath.row] as! Article
            
            cell.articleNameLabel.text = article.name
        
        case groupsCollectionView:
            
            cell = groupsCollectionView.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
            
            let group = fetchedResultsController.fetchedObjects![indexPath.row] as! ArticleGroup
            
            cell.articleNameLabel.text = group.name
            
        default:
            break
        }
        
        return cell
    }
}

extension ArticleManageViewController: NSFetchedResultsControllerDelegate
{
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type
        {
        case .Update:
            
            updateIndexPaths.append(indexPath!)
            
        case .Delete:
            
            deleteIndexPaths.append(indexPath!)
            
        case .Insert:
            
            insertIndexPaths.append(newIndexPath!)
            
        case .Move:
            print("Moved")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        changeItemsInContent()
    }
    
    func toggleCollectionView(collectionView: UICollectionView)
    {
        collectionViewToFetch = collectionView == articlesCollectionView ? .Articles : .Groups
    }
    
    func changeItemsInContent() {
        
        guard let collectionViewToFetch = collectionViewToFetch else { return }
        
        switch collectionViewToFetch.rawValue
        {
        case "ArticleCollectionView":
            
            articlesCollectionView.performBatchUpdates({
                
                for indexPath in self.deleteIndexPaths
                {
                    self.articlesCollectionView.deleteItemsAtIndexPaths([indexPath])
                }
                
                self.deleteIndexPaths = [NSIndexPath]()
                
                for indexPath in self.insertIndexPaths
                {
                    self.articlesCollectionView.insertItemsAtIndexPaths([indexPath])
                }
                
                self.insertIndexPaths = [NSIndexPath]()
                
                for indexPath in self.updateIndexPaths
                {
                    self.articlesCollectionView.reloadItemsAtIndexPaths([indexPath])
                }
                
                self.updateIndexPaths = [NSIndexPath]()
                
            }, completion: nil)
            
        case "ArticleGroupsCollectionView":
            
            groupsCollectionView.performBatchUpdates({
                
                for indexPath in self.deleteIndexPaths
                {
                    self.groupsCollectionView.deleteItemsAtIndexPaths([indexPath])
                }
                
                self.deleteIndexPaths = [NSIndexPath]()
                
                for indexPath in self.insertIndexPaths
                {
                    self.groupsCollectionView.insertItemsAtIndexPaths([indexPath])
                }
                
                self.insertIndexPaths = [NSIndexPath]()
                
                for indexPath in self.updateIndexPaths
                {
                    self.groupsCollectionView.reloadItemsAtIndexPaths([indexPath])
                }
                
                self.updateIndexPaths = [NSIndexPath]()
                
                }, completion: nil)
            
        default:
            break
        }
        
    }
}
