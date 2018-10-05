//
//  PaymentVC.swift
//  PrivateInvestigator
//
//  Created by apple on 8/31/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree


protocol paymentDelegate: class {
    func paymentSuccess(transactionId:String)
}

class PaymentVC: UIViewController {

    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var paymentPurpose:String = ""
    var paymentDescription:String = ""
    var currency:String = "AUD"
    var amount:Double = 0.0
    
    var delegate:paymentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        paymentPurpose = "Registration Fee"
//        paymentDescription = "This is the registration chrage for private eye to use the app."
//        currency = "AUD"
//        amount = 55.0
        loadPaymentDetails()
    }
    
    @IBAction func clickBtnPay(_ sender: Any) {
        showDropIn(clientTokenOrTokenizationKey: "sandbox_zdpmzmbn_wty4q7mk37t6g68w")
    }
    
    @IBAction func clickBtnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupUI() {
       btnPay.roundAllCorners(radius: btnPay.frame.height/2)
        btnCancel.roundAllCorners(radius: btnCancel.frame.height/2)
        btnCancel.addBorder(color: UIColor.init(hexString: "F90413").cgColor, width: 1.5)
    }
    
    func loadPaymentDetails() {
        lblPurpose.text = paymentPurpose
        lblAmount.text = "\(currency) \(amount)"
        lblDescription.text = paymentDescription
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request:BTDropInRequest =  BTDropInRequest()
        request.amount = "50.0"
        request.applePayDisabled = true
        request.paypalDisabled = true
        request.venmoDisabled = false
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                self.delegate?.paymentSuccess(transactionId: "kfkdnkfnkdn")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }

}
