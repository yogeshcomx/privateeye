//
//  SettingsBookerTableViewCell.swift
//  PrivateInvestigator
//
//  Created by apple on 7/28/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class SettingsBookerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOptionIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class SettingsBookerVersionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
