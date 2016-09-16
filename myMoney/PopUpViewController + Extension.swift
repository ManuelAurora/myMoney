//
//  PopUpViewController + modelExtension.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

extension PopUpViewController
{    
    //MARK: Presenting Views
    //TODO: REFACTOR IMPLEMENTATION, NEED TO DELETE REPETITION
    func showArticleView() {
        
        let view = AddEditArticleView.loadFromNib()
        
        view.viewController = self
        view.article        = article
        
        if let imageData = article?.image
        {
            view.articleImageView.image = UIImage(data: imageData)
        }
        
        self.view.addSubview(view)
    }
    
    func showPictureList() {
        
        let view = PictureSelectionView.loadFromNib()
        
        view.viewController = self
        view.pictures       = Pictures()
        
        self.view.addSubview(view)
    }
    
    func showArticleGroupView() {
        
        let view = SelectArticleGroupView.loadFromNib()
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    func chooseAccountView() {
        let view = ChooseAccountView.loadFromNib()
        
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    func showAccountView() {        
        let view = NewAccountView.loadFromNib()
        
        view.mainAccSwitch.isOn = Account.isFirstAccount() // If there is no accounts we will make our first account main.
        
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    //MARK: Completion Handlers
    
    //Adding Article into Check
    func addEditArticleInTablePart(from articleView: AddEditArticleView) {
        
        if let navController = presentingViewController as? UINavigationController, let controller = navController.viewControllers.first as? CheckViewController
        {
            let priceString =  articleView.articlePriceTextField.text!.replacingOccurrences(of: ",", with: ".", options: [], range: nil)
            
            if elementPresentationMode == .elementNewMode
            {
                let articleString = TableString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
                
                 articleString.number = (controller.fetchedResultsController?.sections![0].objects?.count)! + 1 as NSNumber               
            }
            else
            {
                guard let stringToEdit = tableString else { return }
                
                stringToEdit.price = Float(articleView.articlePriceTextField.text!) as NSNumber?
            }          
            
            dismiss(animated: true, completion:nil)
        }
    }
    
    //Adding New Account
    func addNewAccount(from accountView: NewAccountView) {
        
        let tabBar     = presentingViewController   as! UITabBarController
        let controller = tabBar.viewControllers![2] as! AccountManageViewController
        
        let account = Account(withName: "\(accountView.accountNameTextField.text!)")
        
        if accountView.mainAccSwitch.isOn {
            
            account.makeMain()            
        }
        
        if let balance = Double(accountView.balanceTextField.text!)
        {
            let income = Income(withAmount: balance)
            
            income.account = account
            
            _ = RegisterLine(basedOn: income, measure: account, resource: balance, kind: .adding, date: income.date)
        }
        
        if let currency = accountView.currencyLabel.text
        {
            account.currency = currency
        }
        
        // Saving to context 
        
        do
        {
            try DataManager.sharedInstance().saveContext()
              controller.tableView.reloadData()
        }
        catch
        {
            print("Unable to save new Account")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Selecting Article Group
    func selectArticleGroup(from articleGroupView: SelectArticleGroupView) {
        
        if let group = articleGroupView.selectedGroup, let controller = presentingViewController as? AddNewArticleViewController
        {
            controller.article.group = group
            controller.parentButton.setTitle("\(group.name)", for: UIControlState())
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func recieveSelectedImage(_ image: UIImage) {
        
        if let presentingController = presentingViewController as? AddNewArticleViewController
        {
            presentingController.articleImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: >> EXT - UIViewControllerTransitioningDelegate
extension PopUpViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimationController()
    }    
}
