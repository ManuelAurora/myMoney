//
//  AddEditGroupView.swift
//  myMoney
//
//  Created by Мануэль on 29.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class SelectArticleGroupView: UIView
{
    var viewController: PopUpViewController!
    
    var selectedGroup: ArticleGroup? = nil
    
    let allGroups = AllCatalogs.sharedInstance().catalogArticleGroups.allObjects()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func close(sender: UIButton) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didMoveToSuperview() {
        
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "GroupCell")
    }
    
    class func loadFromNib() -> SelectArticleGroupView {
        
        let view = NSBundle.mainBundle().loadNibNamed("SelectGroupView", owner: self, options: nil).first! as! SelectArticleGroupView
        
        return view
    }
}

extension SelectArticleGroupView: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedGroup = allGroups[indexPath.row] as? ArticleGroup
        
        viewController.selectArticleGroup(from: self)
    }
    
    
}

extension SelectArticleGroupView: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! GroupTableViewCell
        
        let group = allGroups[indexPath.row] as! ArticleGroup
        
        if let imageData = group.image
        {
            cell.groupImageView.image = UIImage(data: imageData)
        }
        
        cell.nameLabel.text = group.name
        
        return cell
    }
}