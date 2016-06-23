//
//  DocumentJournalCheckTableViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class DocumentJournalCheckTableViewController: CoreDataTableViewController
{
    
    var managedContext: NSManagedObjectContext!    
    
    var articleCatalog     = AllCatalogs.sharedInstance().catalogArticle
    
    @IBAction func addNewCheck() {
        addCheck()
    }
    
    @IBAction func refresh() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController!.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func addCheck() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Check") as! CheckViewController
        
        controller.managedContext  = managedContext
        controller.articleCatalog  = articleCatalog
        controller.checkNumber     = fetchedResultsController!.fetchedObjects!.count + 1
        controller.mode            = .New
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let expenditure = fetchedResultsController?.objectAtIndexPath(indexPath) as! Expenditure
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckCell", forIndexPath: indexPath) as! CheckTableViewCell
    
        cell.date.text      = String(expenditure.date!)
        cell.number.text    = String(expenditure.number!)
        cell.operation.text = ""
        cell.sum.text       = String(expenditure.sumOfDocument())
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Check") as! CheckViewController
        
        controller.managedContext  = managedContext
        controller.articleCatalog  = articleCatalog
        
        controller.mode  = .Edit
        controller.check = fetchedResultsController!.objectAtIndexPath(indexPath) as? Expenditure
        
        presentViewController(controller, animated: true, completion: nil)        
    }
    
    func fetchData() {
        
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        
        let fetchRequest = NSFetchRequest(entityName: "Expenditure")
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try fetchedResultsController?.performFetch()
            
        } catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
        }
    }
}
