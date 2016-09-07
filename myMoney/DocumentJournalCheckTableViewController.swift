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
    
    let articleCatalog = AllCatalogs.sharedInstance().catalogArticle
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: true)
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckCell", forIndexPath: indexPath) as! CheckTableViewCell
     
        if let document = fetchedResultsController?.objectAtIndexPath(indexPath) as? Registrator
        {
            cell.date.text = prettyStringFrom(document.date)
            cell.sum.text  = prettyStringFrom(document.sumOfDocument())
            
            cell.operation.text = document.name == Constants.expenditureName ? "Expenditure" : "Income"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let document = fetchedResultsController?.objectAtIndexPath(indexPath) as! Registrator
        
        switch document.name
        {
        case Constants.expenditureName:
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("Check") as! CheckViewController
            
            controller.managedContext  = managedContext            
            controller.presentationMode  = .DocumentEditMode
            controller.check             = document
            
            presentViewController(controller, animated: true, completion: nil)
            
        case Constants.incomeName:
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier("Income") as! IncomeViewController
            
            controller.managedContext   = managedContext
            controller.presentationMode = .DocumentEditMode
            controller.income           = document
            
            presentViewController(controller, animated: true, completion: nil)
            
        default:
            
            print("Error")
        }
    }
    
    func fetchData() {        
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        let fetchRequest = NSFetchRequest(entityName: "Registrator")
        
        fetchRequest.sortDescriptors = [sortDescriptor]
     
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try fetchedResultsController!.performFetch()
        }
        catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard editingStyle == .Delete else { return }
        
        let document = fetchedResultsController?.objectAtIndexPath(indexPath) as! Registrator
        
        document.deleteOldRegisterLine()
        
        managedContext.deleteObject(document)
        
        try! managedContext.save()
    }
}
