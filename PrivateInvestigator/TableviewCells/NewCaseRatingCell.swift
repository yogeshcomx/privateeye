//
//  NewCaseRatingCell.swift
//  PrivateInvestigator
//
//  Created by apple on 6/22/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import Cosmos

protocol RatingSelectionDelegate: class {
    func ratingSelected(piRating:Double)
}

class NewCaseRatingCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    var delegate:RatingSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupRatingView()
    }
    
    func setupRatingView() {
        viewRating.settings.fillMode = .half
        viewRating.didTouchCosmos = { rate in
            
        }
        viewRating.didFinishTouchingCosmos = { rate in
            self.delegate?.ratingSelected(piRating: rate)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
