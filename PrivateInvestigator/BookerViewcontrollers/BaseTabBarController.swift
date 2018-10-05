//
//  BaseTabBarController.swift
//  PrivateInvestigator
//
//  Created by apple on 7/17/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        updateFCMToken()
    }
    
    func updateFCMToken() {
        let userId:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        let fcmtoken:String = UserDefaults.standard.string(forKey: fcmTokenUserDefaults) ?? ""
        APIManager.sharedInstance.putUpdateUserFCMtoken(userid: userId, fcmToken: fcmtoken, onSuccess: { status in
        }, onFailure: { error  in
        })
    }

}
