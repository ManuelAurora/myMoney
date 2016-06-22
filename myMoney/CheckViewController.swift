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
    
    @IBAction func record() {
        
        try! DataManager.sharedInstance().saveContext()
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
            number.text = String(check!.number)
            date.text   = String(check!.date)
            
        case .New:
            check = Expenditure(Number: checkNumber)
            AddEditButton.setTitle("Record", forState: .Normal)
            number.text = String(checkNumber)            
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
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func conductProcessing(mode: ProcessingModes) {
        
        let navController = self.presentingViewController as! UINavigationController
        
        let controller = navController.topViewController as! DocumentJournalCheckTableViewController
        
//        switch mode
//        {
//        case .Conduction:
//            
//            check.conduct()
//            
//            check.number = Int(number.text!)!
//            
//            documentsCheckJournal.documents.append(check)
//            
//            
//        case .Saving:
//            check.conduct()
//        }
//        
        
        controller.tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)        
        
    }

}

extension CheckViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return check?.tablePart?.articles?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! ProductCellTableViewCell
        
        let article = check?.tablePart?.articles?.allObjects[indexPath.row] as! Article
        
        cell.name.text = article.name!
        cell.price.text = String(article.price!.floatValue) ?? ""
        
        return cell
    }
}

