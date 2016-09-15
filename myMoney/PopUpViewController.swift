//
//  PopUpViewController.swift
//  myMoney
//
//  Created by Мануэль on 05.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController
{
    var article:     Article?
    var tableString: TableString?
    var accountView: NewAccountView?
    
    var elementPresentationMode: ElementPresentationMode?
    var presentingDocType:       DocumentType?
    var elementType:             PopUpElementType?
    
    @IBAction func close() {
        
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        if let docType = presentingDocType
        {
            switch docType
            {
            case .documentExpenditureType:
                
                showArticleView()
            }
        }
        else if let elementType = elementType
        {
            switch elementType
            {
            case .elementArticleType:
                showArticleView()
                
            case .elementAccountType:
                showAccountView()
                
            case .elementAccountListType:
                chooseAccountView()
                
            case .elementArticleGroupType:
                showArticleGroupView()
            }
        }
    }
}

