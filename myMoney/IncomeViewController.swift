//
//  IncomeViewController.swift
//  myMoney
//
//  Created by Мануэль on 24.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class IncomeViewController: CoreDataTableViewController
{
    var managedContext: NSManagedObjectContext!
    
    var income: Income?
    
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBAction func record(sender: AnyObject) {
        
        try! managedContext.save()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNew(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.docType = .Income
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        income = Income(Number: 1)
        
        fetchData()
        
    }
    
    func fetchData() {
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        let predicate = NSPredicate(format: "tablePart.income = %@", income!)
        
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
}


extension IncomeViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = fetchedResultsController!.sections![section]
        
        return section.objects!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IncomeCell") as! IncomeTableViewCell
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        if let text = articleString.price?.floatValue
        {
            cell.title.text  = "\(text)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let incomeString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        controller.mode    = .Edit
        controller.docType = .Income
        
        controller.tableString = incomeString
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        managedContext.deleteObject(articleString)
    }
}
