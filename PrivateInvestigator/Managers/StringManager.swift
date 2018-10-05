//
//  StringManager.swift
//  PrivateInvestigator
//
//  Created by apple on 6/29/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation

let baseUrl:String = "http://privateeye.urldiary.com/index.php/PIapi/"
let userIdUserDefaults: String = "NSUserDefaultsKeyOfUserId"
let userRoleIdUserDefaults: String = "NSUserDefaultsKeyOfUserRoleId"
let userMobileNumberUserDefaults : String = "NSUserDefaultsKeyOfUserMobileNumber"
let registrationFlowStatusUserDefaults: String = "NSUserDefaultsKeyOfAppFlowStatus"
let userLoginStatusUserDefaults: String = "NSUserDefaultsKeyOfUserLoginStatus"
let userProfileDetailsUserDefaults: String = "NSUserDefaultsKeyOfUserProfileDetails"
let firebaseAuthVerificationID: String = "NSUserDefaultsFirebaseAuthVerificationID"
let googleSignInNotification: String = "GoogleSignInStatusNotification"
let fcmTokenUserDefaults: String = "NSUserDefaultsFcmTokenValue"

let registeredSignUpFlowValue:String = "Registered"
let phoneNumberVerifiedSignUpFlowValue:String = "PhoneNumberVerified"
let profileUpdatedSignUpFlowValue:String = "ProfileUpdated"
let paymentDoneSignUpFlowValue:String = "PaymentDone"
let completedSignUpFlowValue:String = "Completed"



class StringManager {
    
    static let sharedInstance = StringManager()
    
    private init() {
    }
    
    
    
    func validateEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._ %+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    
    
    func validateMobile(text: String) -> Bool {
        if text.count >= 8 && text.count <= 16 {
            return true
        } else {
            return false
        }
    }
    
    
    
    func validatePassword(text: String) -> Bool {
        if text.count >= 8 {
            return true
        } else {
            return false
        }
    }
    
    
    func validateName(text: String) -> Bool {
        if text.count > 0 {
            return true
        } else {
            return false
        }
    }
}
