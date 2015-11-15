//
//  WorkItemCellModel.swift
//  TFS
//
//  Created by Manuel Santizo on 14/11/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class WorkItemCellModel : UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var detailText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}