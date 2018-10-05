//
//  TipsTableViewCell.swift
//  PrivateInvestigator
//
//  Created by apple on 7/19/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

protocol TipsSelectionDelegate: class {
    func tipSelected(selectedCell:TipsTableViewCell)
}

protocol RulesSelectionDelegate: class {
    func ruleSelected(selectedCell:TipsTableViewCell)
}


class TipsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSelectCheckbox: UIButton!
    
    var delegateTips:TipsSelectionDelegate?
    var delegateRules:RulesSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickBtnSelectCheckbox(_ sender: Any) {
        delegateTips?.tipSelected(selectedCell: self)
        delegateRules?.ruleSelected(selectedCell: self)
    }
    
    
}
