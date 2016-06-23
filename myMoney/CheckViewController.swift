//
//  ViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class CheckViewController: UIViewController
{
    var managedContext: NSManagedObjectContext!
    
    var checkNumber: Int!
    var mode: Mode = .New
    var check: Expenditure?
    
    var articleCatalog: Catalog!
    
    @IBOutlet weak var priceField:    UITextField!
    @IBOutlet weak var productView:   UIView!
    @IBOutlet weak var tableView:     UITableView!
    @IBOutlet weak var number:        UILabel!
    @IBOutlet weak var date:          UILabel!
    @IBOutlet weak var AddEditButton: UIButton!
    
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
        
        try! DataManager.sharedInstance().saveContext()
        
        let navController = self.presentingViewController as! UINavigationController
        
        let controller = navController.topViewController as! DocumentJournalCheckTableViewController
        
        controller.fetchData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        tileButtons()
        
        switch mode
        {
        case .Edit:
            AddEditButton.setTitle("Accept", forState: .Normal)
            number.text = String(check!.number!)
            date.text   = String(check!.date!)
            
        case .New:
            check = Expenditure(Number: checkNumber)
            AddEditButton.setTitle("Record", forState: .Normal)
            number.text = String(checkNumber!)
            date.text = String(check!.date!)
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
        
        controller.mode = .New
        
        presentViewController(controller, animated: true, completion: nil)
    }    
}

extension CheckViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return check?.tablePart?.articleStrings?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! ProductCellTableViewCell
        
        let articleString = check?.tablePart?.articleStrings?.allObjects[indexPath.row] as! ArticleString
        
        cell.name.text  = articleString.article!.name
        cell.price.text = String(articleString.price!.floatValue) ?? ""
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        let articleString = check?.tablePart?.articleStrings?.allObjects[indexPath.row] as! ArticleString
        let article       = articleString.article
                
        controller.mode                = .Edit
        controller.article             = article
        controller.indexOfStringToEdit = indexPath
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let articleString = check?.tablePart?.articleStrings?.allObjects[indexPath.row] as! ArticleString
        
        check?.removeArticleInTablePart(Article: articleString)
        
        try! managedContext.save()
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)      
    }
}

