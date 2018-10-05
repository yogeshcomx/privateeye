//
//  FileAttachmentCell.swift
//  PrivateInvestigator
//
//  Created by apple on 9/25/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

protocol FileAttachmentCellDelegate: class {
    func removeAttachment(selectedCell: FileAttachmentCell)
}

class FileAttachmentCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var delegate:FileAttachmentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickBtnDelete(_ sender: Any) {
        delegate?.removeAttachment(selectedCell: self)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
