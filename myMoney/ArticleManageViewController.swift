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
    var updateIndexPaths   = [IndexPath]()
    var deleteIndexPaths   = [IndexPath]()
    var insertIndexPaths   = [IndexPath]()
    
    var collectionViewToFetch: CollectionViewToFetch?
    
    var articleCollectionInEditMode = false
    var groupsCollectionInEditMode  = false
    
    var managedContext: NSManagedObjectContext!
    
    lazy var fetchedResultsControllerArticles: NSFetchedResultsController<Article> = {
        let entityName = "Article"        
        
        let controller = instantiateFetchControllerWithRequest(entity: entityName, predicate: nil, forDelegate: self)
        
        return controller as! NSFetchedResultsController<Article>
    }()
    
    lazy var fetchedResultsControllerArticleGroups: NSFetchedResultsController<ArticleGroup> = {
        
        let entityName = "ArticleGroup"
        
        let controller = instantiateFetchControllerWithRequest(entity: entityName, predicate: nil, forDelegate: self)
        
        return controller as! NSFetchedResultsController<ArticleGroup>
    }()

    @IBOutlet weak var addGroupButton:   UIButton!
    @IBOutlet weak var addArticleButton: UIButton!
    @IBOutlet weak var stopEdingButton:  UIButton!
    
    @IBOutlet weak var groupsCollectionView:   UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    @IBAction func addNewArticle(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewArticle") as! AddNewArticleViewController
        
        controller.managedContext = managedContext
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addNewGroup(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewGroup") as! AddNewGroupViewController
        
        controller.managedContext = managedContext
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func stopEditing(_ sender: UIButton) {
        
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
    
    func updateSectionForDeletionProcess(_ sender: UILongPressGestureRecognizer) {
        
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
    
    func hideAddButtons(_ isHidden: Bool) {
        
        addGroupButton.isHidden   = isHidden
        addArticleButton.isHidden = isHidden
        stopEdingButton.isHidden  = !isHidden
    }
    
    func toggleEditingMode(_ isOn: Bool, inCollection view: UICollectionView)
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
        
        articlesCollectionView.backgroundColor = UIColor.white
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing      = 14
                
        let size = floor(articlesCollectionView.superview!.bounds.width / 4)
       
        layout.itemSize = CGSize(width: size, height: size)
        
        articlesCollectionView.collectionViewLayout = layout
    }
    
    func deleteObject(_ object: NSManagedObject) {
        
        managedContext.delete(object)
        
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
   

    fileprivate func registerNibs() {
        
        let nib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        
        articlesCollectionView.register(nib, forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        groupsCollectionView.register(nib,   forCellWithReuseIdentifier: "ArticleCollectionViewCell")
    }
}

//MARK: >> EXT - UICollectionViewDelegate
extension ArticleManageViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        switch collectionView
        {
        case articlesCollectionView:
            
            guard !articleCollectionInEditMode else
            {
                let article = fetchedResultsControllerArticles.object(at: indexPath)
                
                deleteObject(article)
                
                return
            }
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewArticle") as! AddNewArticleViewController
            
            let article = fetchedResultsControllerArticles.fetchedObjects![(indexPath as NSIndexPath).row]
            
            controller.article        = article
            controller.editMode       = .elementEditMode
            controller.managedContext = managedContext
            
            present(controller, animated: true, completion: nil)
            
        case groupsCollectionView:
            
            let group = fetchedResultsControllerArticleGroups.object(at: indexPath)
            
            guard !groupsCollectionInEditMode else
            {
                deleteObject(group)
                
                return
            }
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewGroup") as! AddNewGroupViewController
            
            controller.managedContext = managedContext
            
            controller.group = group
            
            controller.editMode = .elementEditMode
            
            present(controller, animated: true, completion: nil)
            
        default:
            break
        }
    }
}

//MARK: >> EXT - UICollectionViewDataSource
extension ArticleManageViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var name = ""
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        switch collectionView
        {
        case articlesCollectionView:
            
            let article = fetchedResultsControllerArticles.fetchedObjects![(indexPath as NSIndexPath).row]
            
            name = article.name
            
            if let imageData = article.image
            {
                cell.articleImageView.image = UIImage(data: imageData)
            }
            
            cell.removeButton.isHidden   = articleCollectionInEditMode ? false : true
            
        case groupsCollectionView:
            
            let group = fetchedResultsControllerArticleGroups.fetchedObjects![(indexPath as NSIndexPath).row]
            
            name = group.name
            
            cell.removeButton.isHidden   = groupsCollectionInEditMode ? false : true
            
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
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type
        {
        case .update:
            
            updateIndexPaths.append(indexPath!)
            
        case .delete:
            
            deleteIndexPaths.append(indexPath!)
            
        case .insert:
            
            insertIndexPaths.append(newIndexPath!)
            
        case .move:
            print("Moved")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        changeItemsInContentControlled(by: controller)
    }
    
    func changeItemsInContentControlled(by controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        
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
                collection.deleteItems(at: [indexPath])
            }
            
            self.deleteIndexPaths = [IndexPath]()
            
            for indexPath in self.insertIndexPaths
            {
                collection.insertItems(at: [indexPath])
            }
            
            self.insertIndexPaths = [IndexPath]()
            
            for indexPath in self.updateIndexPaths
            {
                collection.reloadItems(at: [indexPath])
            }
            
            self.updateIndexPaths = [IndexPath]()
            
            }, completion: nil)
    }
    
}
