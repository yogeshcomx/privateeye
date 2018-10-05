//
//  BaseTabBarControllerPrivateEye.swift
//  PrivateInvestigator
//
//  Created by apple on 8/20/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class BaseTabBarControllerPrivateEye: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
