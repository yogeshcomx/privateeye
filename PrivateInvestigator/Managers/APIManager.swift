//
//  APIManager.swift
//  PrivateInvestigator
//
//  Created by apple on 6/26/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIManager {
    
    static let sharedInstance = APIManager()
    
    private init() {
    }
    
    
    //Getting Countries List from Server
    func getCountryCodeList(onSuccess: @escaping([Country]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_countries_list"
        Alamofire.request(url, method: HTTPMethod.get , parameters: nil, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let countries:[Country] = JsonDataManager.sharedInstance.parseCountryDataFromServer(JSONData: response.data!)
                onSuccess(countries)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User Registration
    func postRegister(email:String, countryCode:String, mobile:String, userRole:String, password:String, facebookId:String, googleId:String, onSuccess: @escaping(String,String) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"register"
        let parameters: Parameters = [
            "email": email,
            "password": password,
            "mobile" : mobile,
            "country_code" : countryCode,
            "role_id" : userRole,
            "google_uid" : googleId,
            "facebook_uid" : facebookId
            ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let (userID,message) = JsonDataManager.sharedInstance.parseRegisterDataFromServer(JSONData: response.data!)
                if userID != "" {
                    onSuccess(userID, message)
                } else {
                   onSuccess(userID,message)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Phone Number Verification with OTP
    func getPhoneNumberVerification(mobile:String, otp:String, onSuccess: @escaping(Bool,String) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"otp_verify?mobile=\(mobile)&otp_code=\(otp)"
        Alamofire.request(url, method: HTTPMethod.get , parameters: nil, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let (status,message) = JsonDataManager.sharedInstance.parseOTPVerificationDataFromServer(JSONData: response.data!)
                onSuccess(status,message)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Resend OTP to Mobile
    func putResendOTPmobile(mobile:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"re_send_otp"
        let parameters: Parameters = [
            "mobile" : mobile
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseResendOTPDataFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User Log In
    func postLogin(mobile:String, password:String, onSuccess: @escaping(String,String,String,String) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"login"
        let parameters: Parameters = [
            "password": password,
            "mobile" : mobile
        ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let (userID,roleID,phoneVerified,message) = JsonDataManager.sharedInstance.parseLoginDataFromServer(JSONData: response.data!)
                if userID != "" {
                    onSuccess(userID,roleID,phoneVerified,message)
                } else {
                    onSuccess(userID,roleID,phoneVerified,message)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User Profile Details Update
    func putUpdateUserProfileDetails(userid:String, firstname:String, lastname:String, gender:String, dob:String, address:String, street:String, city:String, state:String, country:String, zipcode:String, userLat:Double, userLng:Double, currentEmp:String, equipmentTags:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_user_profile"
        let parameters: Parameters = [
            "userId" : userid,
            "first_name" : firstname,
            "last_name" : lastname,
            "gender" : gender,
            "dob" : dob,
            "address" : address,
            "street" : street,
            "city" : city,
            "state" : state,
            "country" : country,
            "zipcode" : zipcode,
            "current_emp" : currentEmp,
            "tag_your_equipment" : equipmentTags,
            "homeLatitude" : userLat,
            "homeLongitude" : userLng
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseUpdateUserDetailsFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Getting Case Type List from Server
    func getCaseTypeList(onSuccess: @escaping([CaseType]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_case_type_list"
        Alamofire.request(url, method: HTTPMethod.get , parameters: nil, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let caseTypes:[CaseType] = JsonDataManager.sharedInstance.parseCaseTypeDataFromServer(JSONData: response.data!)
                onSuccess(caseTypes)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Getting Case Live Status Feed Options List from Server
    func getCaseLiveStatusOptionsList(onSuccess: @escaping([CaseLiveStatus]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_case_live_status_list"
        Alamofire.request(url, method: HTTPMethod.get , parameters: nil, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let caseLiveStatusOptions:[CaseLiveStatus] = JsonDataManager.sharedInstance.parseCaseLiveStatusOptionsDataFromServer(JSONData: response.data!)
                onSuccess(caseLiveStatusOptions)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Getting Tips List from Server
    func getTipsListList(onSuccess: @escaping([TipsForCaseType]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_tips_list"
        let roleid = UserDefaults.standard.string(forKey: userRoleIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "user_type_id" : roleid,
        ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let tipsList:[TipsForCaseType] = JsonDataManager.sharedInstance.parseTipsDataFromServer(JSONData: response.data!)
                onSuccess(tipsList)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    //Getting Rules List from Server
    func getRulesList(onSuccess: @escaping([RulesForCaseType]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_rules_list"
        let roleid = UserDefaults.standard.string(forKey: userRoleIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "user_type_id" : roleid,
            ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let rulesList:[RulesForCaseType] = JsonDataManager.sharedInstance.parseRulesDataFromServer(JSONData: response.data!)
                onSuccess(rulesList)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Getting Tags List from Server
    func getTagsList(onSuccess: @escaping([String]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_tags_list"
        Alamofire.request(url, method: HTTPMethod.get , parameters: nil, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let tagsList:[String] = JsonDataManager.sharedInstance.parseTagsDataFromServer(JSONData: response.data!)
                onSuccess(tagsList)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Getting Profile Details
    func postGetUserProfileDetails(onSuccess: @escaping([String : String]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_user_profile"
        let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "userId": userid
        ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let userDetails:[String: String] = JsonDataManager.sharedInstance.parseGetUserProfileDetailsDataFromServer(JSONData: response.data!)
                onSuccess(userDetails)
            } else {
                onFailure(response.error!)
            }
        }
    }
    

    //Create New Case Booker
    func postCreateNewCase(caseTypeId:String, caseTypeTitle:String, caseMinTime:String, caseTime:String, poiName:String, poiType:String, poiAge:String, poiGender:String, poiTargetIdentityTags:String, secondSuspect:String, caseDescription:String, poiImages:[UIImage], caseLocationName:String, caseLocationAddress:String, caseLat:Double, caseLng:Double, caseDate:String, caseStartTime:String, expectedOutcomes:String, tipsIds:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"store_case_details"
        let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "booker_Id": userid,
            "case_type_Id" : caseTypeId,
            "case_type" : caseTypeTitle,
            "case_minimum_time" : caseMinTime,
            "case_length" : caseTime,
            "case_location_name" : caseLocationName,
            "case_location_address" : caseLocationAddress,
            "case_latitude" : caseLat,
            "case_longitude" : caseLng,
            "person_of_interest" : poiName,
            "gender_of_POI" : poiGender,
            "age_of_POI" : poiAge,
            "target_identification" : poiTargetIdentityTags,
            "images_of_POI" : "upload.jpg",
            "job_description" : caseDescription,
            "second_suspect" : secondSuspect,
            "type_of_POI" : poiType,
            "case_date" : caseDate,
            "case_start_time" : caseStartTime,
            "outcome_required" : expectedOutcomes,
            "tips_tags_for_booker" : tipsIds
        ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseCreateNewCaseBookerDataFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //Get all Case List of Booker
    func postGettingCaseListOfBooker(onSuccess: @escaping([CaseDetails]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_all_case_list_of_booker"
        let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "booker_Id" : userid,
            ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let caseList:[CaseDetails] = JsonDataManager.sharedInstance.parseCaseListForBookerDataFromServer(JSONData: response.data!)
                onSuccess(caseList)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    //Get all Case List of PrivateEye
    func postGettingCaseListOfPrivateEye(onSuccess: @escaping([CaseDetails]) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"get_all_case_list_of_private_eye"
        let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        let parameters: Parameters = [
            "PI_accepted_Id" : userid,
            ]
        Alamofire.request(url, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default , headers: [:]).responseJSON { response in
            if response.data != nil {
                let caseList:[CaseDetails] = JsonDataManager.sharedInstance.parseCaseListForPrivateEyeDataFromServer(JSONData: response.data!)
                onSuccess(caseList)
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User Current Location Details Update
    func putUpdateUserCurrentLocation(userid:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_user_currentLocation"
        let parameters: Parameters = [
            "userId" : userid,
            "currentLatitude" : currentLatitude ?? 0.0,
            "currentLongitude" : currentLongitude ?? 0.0
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseUpdateUserCurrentLocationFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User FCM Token Details Update
    func putUpdateUserFCMtoken(userid:String, fcmToken:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_user_FCM_Token"
        let parameters: Parameters = [
            "userId" : userid,
            "FCM_Token" : fcmToken,
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseUpdateUserFcmTokenStatusFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //User Phone Number Verification Status Update
    func putUpdateUserPhoneNumberVerificationStatus(userid:String, verifiedPhone:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_user_verify"
        let parameters: Parameters = [
            "userId" : userid,
            "verify" : verifiedPhone
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseUpdateUserPhoneNumberVerificationStatusFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    //PI Accept the case created by Booker
    func putAcceptCase(caseid:String, userid:String, onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_user_verify"
        let parameters: Parameters = [
            "caseId" : caseid,
            "PI_accepted_Id" : userid
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseAcceptCaseStatusFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
    
    //PI Updates the Case live Status Feed
    func putUpdateCaseLiveStatusFeed(caseid:String, userid:String, liveStatus: CaseLiveStatus,onSuccess: @escaping(Bool) -> Void, onFailure: @escaping(Error) -> Void) {
        let url = baseUrl+"update_case_live_status"
        let parameters: Parameters = [
            "caseId" : caseid,
            "PI_accepted_Id" : userid,
            "live_status_description" : liveStatus.liveStatusDescription
        ]
        Alamofire.request(url, method: HTTPMethod.put , parameters: parameters, encoding: URLEncoding.httpBody , headers: [:]).responseJSON { response in
            if response.data != nil {
                let status = JsonDataManager.sharedInstance.parseUpdateCaseLiveStatusFeedDataFromServer(JSONData: response.data!)
                if status {
                    onSuccess(status)
                } else {
                    onSuccess(status)
                }
            } else {
                onFailure(response.error!)
            }
        }
    }
    
    
}
