//
//  NewCaseDescriptionCell.swift
//  PrivateInvestigator
//
//  Created by apple on 9/7/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

protocol CaseDescriptionTextDelegate: class {
    func caseDescriptionTextChanged(descriptionText:String)
}


class NewCaseDescriptionCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var txtCaseDescription: UITextView!
    
    var delegate:CaseDescriptionTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtCaseDescription.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.caseDescriptionTextChanged(descriptionText: txtCaseDescription.text!)
    }
    
    
    
}
