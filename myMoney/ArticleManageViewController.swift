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
    
    var articleCollectionInEditMode = false
    var groupsCollectionInEditMode  = false
    
    var managedContext: NSManagedObjectContext!
    
    lazy var fetchedResultsControllerArticles: NSFetchedResultsController = {
        
        let entityName = "Article"
       
        let predicate = NSPredicate(format: "basedOnGroup=%@", NSNumber(bool: false))
        
        let controller = instantiateFetchControllerWithRequest(entity: entityName, predicate: predicate, forDelegate: self)
        
        return controller
    }()
    
    lazy var fetchedResultsControllerArticleGroups: NSFetchedResultsController = {
        
        let entityName = "ArticleGroup"
        
        let controller = instantiateFetchControllerWithRequest(entity: entityName, predicate: nil, forDelegate: self)
        
        return controller
        
    }()

    @IBOutlet weak var addGroupButton:   UIButton!
    @IBOutlet weak var addArticleButton: UIButton!
    @IBOutlet weak var stopEdingButton:  UIButton!
    
    @IBOutlet weak var groupsCollectionView:   UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    @IBAction func addNewArticle(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewArticle") as! AddNewArticleViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addNewGroup(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewGroup") as! AddNewGroupViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func stopEditing(sender: UIButton) {
        
        if articleCollectionInEditMode
        {
            toggleEditingMode(false, inCollection: articlesCollectionView)
        }
        else if groupsCollectionInEditMode
        {
            toggleEditingMode(false, inCollection: groupsCollectionView)
        }
        
        hideAddButtons(false)
    }
    
    func addGestureRecognizerForDeletion() {
        
        groupsCollectionView.addGestureRecognizer(  makeGesturesFor(collection: groupsCollectionView))
        articlesCollectionView.addGestureRecognizer(makeGesturesFor(collection: articlesCollectionView))
    }
    
    func makeGesturesFor(collection view: UICollectionView) -> UILongPressGestureRecognizer {
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.updateSectionForDeletionProcess(_:)))
        
        gesture.minimumPressDuration = 1.5
        gesture.delegate = self

        return gesture
    }
    
    func updateSectionForDeletionProcess(sender: UILongPressGestureRecognizer) {
        
        let collection = sender.view as! UICollectionView
        
        switch collection
        {
        case articlesCollectionView:
            toggleEditingMode(true, inCollection: articlesCollectionView)
            
        case groupsCollectionView:
            toggleEditingMode(true, inCollection: groupsCollectionView)
            
        default:
            break
        }
        
        hideAddButtons(true)        
    }
    
    func hideAddButtons(isHidden: Bool) {
        
        addGroupButton.hidden   = isHidden
        addArticleButton.hidden = isHidden
        stopEdingButton.hidden  = !isHidden
    }
    
    func toggleEditingMode(isOn: Bool, inCollection view: UICollectionView)
    {
        switch view
        {
        case articlesCollectionView:
            articleCollectionInEditMode = isOn
            articlesCollectionView.reloadData()
            
        case groupsCollectionView:
            groupsCollectionInEditMode = isOn
            groupsCollectionView.reloadData()
            
        default:
            break
            
        }
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
    
    func deleteObject(object: NSManagedObject) {
        
        managedContext.deleteObject(object)
        
        do
        {
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        
       addGestureRecognizerForDeletion()
        
       registerNibs()
        
       makeCustomLayout()
    }
   

    private func registerNibs() {
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        
        articlesCollectionView.registerNib(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        groupsCollectionView.registerNib(nib,   forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
}

//MARK: >> EXT - UICollectionViewDelegate
extension ArticleManageViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        switch collectionView
        {
        case articlesCollectionView:
            
            guard !articleCollectionInEditMode else
            {
                let article = fetchedResultsControllerArticles.objectAtIndexPath(indexPath) as! Article
                
                deleteObject(article)
                
                return
            }
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewArticle") as! AddNewArticleViewController
            
            let article = fetchedResultsControllerArticles.fetchedObjects![indexPath.row] as! Article
            
            controller.article        = article
            controller.editMode       = .ElementEditMode
            controller.managedContext = managedContext
            
            presentViewController(controller, animated: true, completion: nil)
            
        case groupsCollectionView:
            
            let group = fetchedResultsControllerArticleGroups.objectAtIndexPath(indexPath) as! ArticleGroup
            
            guard !groupsCollectionInEditMode else
            {
                deleteObject(group)
                
                return
            }
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewGroup") as! AddNewGroupViewController
            
            controller.managedContext = managedContext
            
            controller.group = group
            
            controller.editMode = .ElementEditMode
            
            presentViewController(controller, animated: true, completion: nil)
            
        default:
            break
        }
    }
}

//MARK: >> EXT - UICollectionViewDataSource
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
        
        var name = ""
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArticleCollectionViewCell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        switch collectionView
        {
        case articlesCollectionView:
            
            let article = fetchedResultsControllerArticles.fetchedObjects![indexPath.row] as! Article
            
            name = article.name
            
            cell.removeButton.hidden   = articleCollectionInEditMode ? false : true
            
        case groupsCollectionView:
            
            let group = fetchedResultsControllerArticleGroups.fetchedObjects![indexPath.row] as! ArticleGroup
            
            name = group.name
            
            cell.removeButton.hidden   = groupsCollectionInEditMode ? false : true
            
        default:
            break
        }
        
        cell.articleNameLabel.text = name        
        
        return cell
    }
}

//MARK: >> EXT - UIGestureRecognizerDelegate
extension ArticleManageViewController: UIGestureRecognizerDelegate
{
    
}

//MARK: >> EXT - NSFetchedResultsControllerDelegate
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
