//
//  ViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class CheckViewController: CoreDataTableViewController
{
    var managedContext: NSManagedObjectContext!
    var checkNumber:    Int!
    var articleCatalog: Catalog!
    
    var check: Registrator?
  
    var presentationMode: DocumentPresentationMode = .DocumentNewMode
    
    var totalExpense: Double = 0
    
    @IBOutlet weak var productView:   UIView!
    @IBOutlet weak var date:          UILabel!
    @IBOutlet weak var AddEditButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    @IBAction func chooseAccount(sender: AnyObject) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.elementType = .ElementAccountListType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func addNewArticle() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("addNewArticle") as! AddNewArticleViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func Cancel() {
    
        dismissViewControllerAnimated(true, completion: nil)
        managedContext.rollback()
    }
    
    @IBAction func record() {
   
        guard let check = check else { return }
        
        switch presentationMode
        {
        case .DocumentEditMode:
            
            check.deleteOldRegisterLine()
            check.conduct()
            
        case .DocumentNewMode:
            
            check.conduct()
        }        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch presentationMode
        {
        case .DocumentEditMode:
            AddEditButton.setTitle("Save", forState: .Normal)
            date.text   = String(check!.date)
            
        case .DocumentNewMode:
            
            check = Expenditure(Number: checkNumber)
            
            AddEditButton.setTitle("Add", forState: .Normal)
        }
        
        date.text = prettyStringFrom(check!.date)
        
        fetchData()
        
        tileButtons()        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = check?.account.name
        {
            accountButton.setTitle(name, forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tileButtons() {
        
        let articleCatalog = try! DataManager.sharedInstance().context.executeFetchRequest(NSFetchRequest(entityName: "Article")) as! [Article]
        
        var rows    = 3
        var columns = 5
        
        var marginX:    CGFloat    = 0
        var marginY:    CGFloat    = 20
        
        let productViewWidth = productView.bounds.size.width
        
        switch productViewWidth
        {
        case 568:
            columns = 6; marginX = 2
        case 667:
            columns = 7; marginX = 1; marginY = 29;
        case 736:
            rows = 4;    columns = 8;
        default:
            break
        }
        
        var row    = 0
        var column = 0
        var x      = marginX
        
        let buttonWidth: CGFloat  = 60
        let buttonHeight: CGFloat = 60
        
        let paddingHorz = (buttonWidth) / 3
        let paddingVert = (buttonHeight) / 2
        
        for (index, product) in articleCatalog.enumerate() {
            
            print(product.name)
            
            let button = UIButton(type: .Custom)
            let image  = UIImage(named: "LandscapeButton")
            let label  = UILabel()
            
            label.text  = product.name
            label.backgroundColor = UIColor.whiteColor()
            
            button.setBackgroundImage(image, forState: .Normal)
            
            button.frame =  CGRect(x: x + paddingHorz,
                                   y: marginY + CGFloat(row) * buttonHeight,
                                   width: buttonWidth,
                                   height: buttonHeight)
            
            label.frame = CGRect(x: button.bounds.origin.x, y: button.bounds.origin.x, width: buttonWidth, height: buttonHeight / 3)
            label.tag = 1000 + index
            
            button.addSubview(label)
            
            productView.addSubview(button)
            
            button.tag = 2000 + index
            
            button.addTarget(self, action: #selector(buttonPressed), forControlEvents: .TouchUpInside)
            
            row += 1
            
            if row == rows {
                row = 0; x += buttonWidth; column += 1
                
                if column == columns {
                    column = 0; x += marginX * 2
                }
            }
        }      
    }    
    
    func buttonPressed(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let index = sender.tag - 2000
        
        let article = articleCatalog.allObjects()[index] as! Article
        
        controller.article = article
        
        controller.elementPresentationMode = .ElementNewMode
        controller.elementType             = .ElementArticleType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func fetchData() {
        
        let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
        
        let predicate = NSPredicate(format: "tablePart.expenditure = %@", check!)
        
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
    
    func renumerateStrings() {
        
        var number = 1
        
        for string in fetchedResultsController!.fetchedObjects! as! [TableString]
        {
            if !string.deleted {
                string.number = number
                number += 1
            }
        }
    }    
}

extension CheckViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = fetchedResultsController!.sections![section]
        
        return section.objects!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell") as! ArticleCellTableViewCell
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        cell.name.text  = articleString.article!.name
        cell.price.text = String(articleString.price!.floatValue) ?? ""
        cell.number.text = String(indexPath.row + 1)
        
        totalExpense += articleString.price!.doubleValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let tableString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        let article = tableString.article
        
        controller.elementPresentationMode = .ElementEditMode
        controller.elementType             = .ElementArticleType
        
        controller.article     = article
        controller.tableString = tableString
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let articleString = fetchedResultsController?.objectAtIndexPath(indexPath) as! TableString
        
        managedContext.deleteObject(articleString)
        
        renumerateStrings()
    }
}

