//
//  DocumentJournalCheckTableViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class DocumentJournalCheckTableViewController: UITableViewController {
    
    let documentsCheckJournal = AllDocuments.sharedInstance().documentsChecksJournal
    var catalogExpenditure    = AllCatalogs.sharedInstance().catalogExpenditure
    
    @IBAction func addNewCheck() {
        addEditCheck(.New)
    }
    
    @IBAction func refresh() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let banana = Expenditure(name: "Banana")
        let paw    = Expenditure(name: "Paw")

        catalogExpenditure.items.append(banana)
        catalogExpenditure.items.append(paw)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return documentsCheckJournal.documents.count
    }
    
    func addEditCheck(mode: Mode) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Check") as! CheckViewController
                
        switch mode {
            
        case .Edit(let index):
            
            controller.check = documentsCheckJournal.documents[index!] as! Check
            controller.check.mode = mode
        default:
            break
        }
        
        presentViewController(controller, animated: true, completion: nil)

    }
    
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let check = documentsCheckJournal.documents[indexPath.row] as! Check
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckCell", forIndexPath: indexPath) as! CheckTableViewCell
        
        cell.date.text      = String(check.date)
        cell.number.text    = String(check.number)
        cell.operation.text = check.operation
        cell.sum.text       = String(check.sumOfDocument)
      
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       
        addEditCheck(.Edit(indexPath.row))
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
