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
    
    var managedContext: NSManagedObjectContext!
    
    lazy var fetchedResultsControllerArticles: NSFetchedResultsController = {
        
        let entityName = "Article"
       
        let controller = instantiateFetchControllerWithRequest(entity: entityName, forDelegate: self)       
        
        return controller
    }()
    
    lazy var fetchedResultsControllerArticleGroups: NSFetchedResultsController = {
        
        let entityName = "ArticleGroup"
        
        let controller = instantiateFetchControllerWithRequest(entity: entityName, forDelegate: self)
        
        return controller
        
    }()

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
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("addNewArticle") as! AddNewArticleViewController
            
            let article = fetchedResultsControllerArticles.fetchedObjects![indexPath.row] as! Article
            
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
        
        var result = 0
        
        switch collectionView
        {
        case articlesCollectionView:
            
            result = fetchedResultsControllerArticles.fetchedObjects!.count
            
        case groupsCollectionView:
            
            result = fetchedResultsControllerArticleGroups.fetchedObjects!.count
            
        default:
            break
        }

        
        return result
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var collection: UICollectionView?
        
        var name = ""
        
        switch collectionView
        {
        case articlesCollectionView:
            
            collection = articlesCollectionView
            
            let article = fetchedResultsControllerArticles.fetchedObjects![indexPath.row] as! Article
            
            name = article.name
            
        case groupsCollectionView:
            
            collection = groupsCollectionView
            
            let group = fetchedResultsControllerArticleGroups.fetchedObjects![indexPath.row] as! ArticleGroup
            
            name = group.name
            
        default:
            break
        }
        
        let cell = collection?.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        cell.articleNameLabel.text = name
        
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
        
        changeItemsInContentControlled(by: controller)
    }
    
    func changeItemsInContentControlled(by controller: NSFetchedResultsController) {
        
        
        var collectionView: UICollectionView?
        
        switch controller
        {
        case fetchedResultsControllerArticles:
            
            collectionView = articlesCollectionView
            
        case fetchedResultsControllerArticleGroups:
            
            collectionView = groupsCollectionView
            
        default:
            break
        }
        
        guard let collection = collectionView else { return }
        
        collection.performBatchUpdates({
            
            for indexPath in self.deleteIndexPaths
            {
                collection.deleteItemsAtIndexPaths([indexPath])
            }
            
            self.deleteIndexPaths = [NSIndexPath]()
            
            for indexPath in self.insertIndexPaths
            {
                collection.insertItemsAtIndexPaths([indexPath])
            }
            
            self.insertIndexPaths = [NSIndexPath]()
            
            for indexPath in self.updateIndexPaths
            {
                collection.reloadItemsAtIndexPaths([indexPath])
            }
            
            self.updateIndexPaths = [NSIndexPath]()
            
            }, completion: nil)
    }
    
}
