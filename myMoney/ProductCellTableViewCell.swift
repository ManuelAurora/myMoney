//
//  ProductCellTableViewCell.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class ProductCellTableViewCell: UITableViewCell
{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
