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
    
    @IBAction func close(_ sender: UIButton) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func didMoveToSuperview() {
        
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "GroupCell")
    }
    
    class func loadFromNib() -> SelectArticleGroupView {
        
        let view = Bundle.main.loadNibNamed("SelectGroupView", owner: self, options: nil)?.first! as! SelectArticleGroupView
        
        return view
    }
}

extension SelectArticleGroupView: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedGroup = allGroups[(indexPath as NSIndexPath).row] as? ArticleGroup
        
        viewController.selectArticleGroup(from: self)
    }
    
    
}

extension SelectArticleGroupView: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupTableViewCell
        
        let group = allGroups[(indexPath as NSIndexPath).row] as! ArticleGroup
        
        if let imageData = group.image
        {
            cell.groupImageView.image = UIImage(data: imageData as Data)
        }
        
        cell.nameLabel.text = group.name
        
        return cell
    }
}
