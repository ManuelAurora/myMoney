//
//  ViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController
{
    var allChecks: [Check]!
    var catalogExpenditure: Catalog!
    
    let check    = Check()
    let register = Register()
    
    @IBOutlet weak var priceField:  UITextField!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var tableView:   UITableView!
    @IBOutlet weak var number:      UILabel!
    @IBOutlet weak var date:        UILabel!
    
    @IBAction func addNewExpenditure() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("AddNewExpend") as! AddNewItemOfExpenditureViewController
        
        controller.catalogOfExpenditure = catalogExpenditure
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func record() {
        check.conduct(register)
        
        check.number = Int(number.text!)!
                
        let navController = self.presentingViewController as! UINavigationController
        
        let controller = navController.topViewController as! DocumentJournalCheckTableViewController
        
        controller.allChecks.append(check)
        
        
        dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tileButtons()
        number.text = String(allChecks!.count + 1)
        date.text   = String(NSDate())        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func tileButtons() {
        
        var rows    = 3
        var columns = 5
        
        var marginX:    CGFloat    = 0
        var marginY:    CGFloat    = 20
        var itemWidth:  CGFloat    = 96
        var itemHeight: CGFloat    = 88
        
        let productViewWidth = productView.bounds.size.width
        
        switch productViewWidth
        {
        case 568:
            columns = 6; marginX = 2
        case 667:
            columns = 7; marginX = 1; marginY = 29; itemWidth = 95; itemHeight = 98
        case 736:
            rows = 4;    columns = 8; itemWidth = 92
        default:
            break
        }
        
        var row    = 0
        var column = 0
        var x      = marginX
        
        let buttonWidth: CGFloat  = 82
        let buttonHeight: CGFloat = 82
        
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        for (index, product) in catalogExpenditure.items.enumerate() {
            
            let button = UIButton(type: .Custom)
            let image  = UIImage(named: "LandscapeButton")
            let label  = UILabel()
            
            label.text  = product.name
            label.backgroundColor = UIColor.whiteColor()
            
            button.setBackgroundImage(image, forState: .Normal)
            
            button.frame =  CGRect(x: x + paddingHorz,
                                   y: marginY + CGFloat(row) * itemHeight + paddingVert,
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
                row = 0; x += itemWidth; column += 1
                
                if column == columns {
                    column = 0; x += marginX * 2
                }
            }
        }
    }
    
    
    func buttonPressed(sender: UIButton) {
        
        let label =  sender.viewWithTag(sender.tag - 1000) as! UILabel
        
        let product = Expenditure(name: label.text!)
        let price = Float(priceField.text!)!
        
        check.prices.append(price)
        
        check.products.append(product)
        
        tableView.reloadData()
        
        priceField.text = ""
    }

}

extension CheckViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return check.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let product = check.products[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! ProductCellTableViewCell
        
        cell.name.text  = product.name
        cell.price.text = String(check.prices[indexPath.row])
    
        return cell
    }
}

