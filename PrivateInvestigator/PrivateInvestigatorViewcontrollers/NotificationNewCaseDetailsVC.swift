//
//  NotificationNewCaseDetailsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 8/30/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class NotificationNewCaseDetailsVC: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var lblCaseType: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    
    var currentCase:CaseDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCaseDetails()
    }
    
    @IBAction func clickBtnClose(_ sender: Any) {
    }
    
    
    @IBAction func clickBtnAccept(_ sender: Any) {
    }
    
    
    @IBAction func clickBtnReject(_ sender: Any) {
    }
    
    
    func setupUI() {
        btnAccept.roundAllCorners(radius: btnAccept.frame.height/2)
        btnReject.roundAllCorners(radius: btnReject.frame.height/2)
    }
    
    func loadCaseDetails() {
        
    }
    

}
