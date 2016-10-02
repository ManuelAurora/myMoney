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
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    var managedContext: NSManagedObjectContext!
    
    let articleCatalog = AllCatalogs.sharedInstance().catalogArticle
        
    @IBAction func recalculateData(_ sender: UISegmentedControl) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        tableView.reloadData()        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        loadPeriod()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController!.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController?.sections?[section]
        
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckTableViewCell
     
        if let document = fetchedResultsController?.object(at: indexPath) as? Registrator
        {
            cell.date.text = prettyStringFrom(document.date)
            cell.sum.text  = prettyStringFrom(document.sumOfDocument())
            
            cell.operation.text = document.name == Constants.expenditureName ? "Expenditure" : "Income"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let document = fetchedResultsController?.object(at: indexPath) as! Registrator
        
        switch document.name
        {
        case Constants.expenditureName:
            
            let controller    = storyboard?.instantiateViewController(withIdentifier: "Check") as! CheckViewController
            let navController = UINavigationController(rootViewController: controller)
            
            controller.managedContext   = managedContext
            controller.presentationMode = .documentEditMode
            controller.check            = document
            
            present(navController, animated: true, completion: nil)
            
        case Constants.incomeName:
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "Income") as! IncomeViewController
            
            controller.managedContext   = managedContext
            controller.presentationMode = .documentEditMode
            controller.income           = document
            
            present(controller, animated: true, completion: nil)
            
        default:
            
            print("Error")
        }
    }
    
    func loadPeriod() {
        
        let defaults = UserDefaults.standard
        
        let index = defaults.integer(forKey: "Period")
        
        periodSegmentedControl.selectedSegmentIndex = index
    }
    
    func formArrayOfPredicatesFor(_ currentPeriod: (periodStart: NSDate, periodEnd: NSDate)) -> [NSPredicate] {
        
        let predicate  = NSPredicate(format: "date>=%@", currentPeriod.periodStart) // 1) if date of the documents is more than current day's begin time
        let predicate2 = NSPredicate(format: "date<=%@", currentPeriod.periodEnd)   // 2) and if date of the documents is less than current day's end time
        
        return [predicate, predicate2]
    }
    
    func fetchData() {
        
        var predicates = [NSPredicate]()
        
        switch periodSegmentedControl.selectedSegmentIndex
        {
        case 0:
            let thisDay = currentPeriodBorder(.Day)
            
            predicates.append(contentsOf:formArrayOfPredicatesFor(thisDay))
            
        case 1:
            let thisWeek = currentPeriodBorder(.Week)
            
            predicates.append(contentsOf: formArrayOfPredicatesFor(thisWeek))
            
        case 2:
            
            let thisMonth = currentPeriodBorder(.Month)
            
            predicates.append(contentsOf: formArrayOfPredicatesFor(thisMonth))
            
        default:
            break
        }
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        if #available(iOS 10.0, *)
        {
            fetchRequest = Registrator.fetchRequest()
        }
        else
        {
            fetchRequest = NSFetchRequest(entityName: "Registrator")
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = compoundPredicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do
        {
            try fetchedResultsController?.performFetch()
        }
        catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let document = fetchedResultsController?.object(at: indexPath) as! Registrator
        
        document.deleteOldRegisterLine()
        
        managedContext.delete(document)
        
        try! managedContext.save()
    }
}
