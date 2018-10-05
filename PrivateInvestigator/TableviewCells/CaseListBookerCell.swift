//
//  CaseListBookerCell.swift
//  PrivateInvestigator
//
//  Created by apple on 7/23/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class CaseListBookerCell: UITableViewCell {

    
    @IBOutlet weak var imgPOI: UIImageView!
    @IBOutlet weak var lblPOIName: UILabel!
    @IBOutlet weak var lblPOIType: UILabel!
    @IBOutlet weak var lblPOIAddress: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCaseDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgPOI.roundAllCorners(radius: 40.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
