//
//  JsonDataManager.swift
//  PrivateInvestigator
//
//  Created by apple on 6/28/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation

class JsonDataManager {
    
    static let sharedInstance = JsonDataManager()
    
    private init() {
    }
    
    
    
    func parseCountryDataFromFile(JSONData: Data?) -> [Country] {
        var countries: [Country] = []
        guard let data = JSONData else {
            return countries
        }
        do {
            countries = try JSONDecoder().decode([Country].self, from: data)
        } catch let jsonError {
            print(jsonError)
        }
        return countries
    }
    
    
    
    func parseCountryDataFromServer(JSONData: Data?) -> [Country] {
        var countries: [Country] = []
        guard let data = JSONData else {
            return countries
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let countriesJson = json!["countries_list"] as? [[String: String]] ?? []
            for country in countriesJson {
                let countryValue:Country = Country(id: country["id"] as? String ?? "", country_name: country["country_name"] as? String ?? "", country_code: country["country_code"] as? String ?? "")
                countries.append(countryValue)
            }
            return countries
        } catch let jsonError {
            print(jsonError)
        }
        return countries
    }
    
    
    func parseCaseTypeDataFromServer(JSONData: Data?) -> [CaseType] {
        var caseTypes: [CaseType] = []
        guard let data = JSONData else {
            return caseTypes
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let caseTypeJson = json!["case_type_list"] as? [[String: String]] ?? []
            for caseType in caseTypeJson {
                let caseValue:CaseType = CaseType(id: caseType["id"] ?? "", case_type: caseType["case_type"] as? String ?? "", min_length_with_travel: caseType["min_length_with_travel"] as? String ?? "", min_notice: caseType["min_notice"] as? String ?? "", distance_limit: caseType["distance_limit"] as? String ?? "", equipment_set: caseType["equipment_set"] as? String ?? "", actions: caseType["actions"] as? String ?? "", mandatory: caseType["mandatory"] as? String ?? "", more_than_one_target: caseType["more_than_one_target"] as? Bool ?? false, persuit_by_car: caseType["persuit_by_car"] as? Bool ?? false, booker_notes: caseType["booker_notes"] as? String ?? "", PI_notes: caseType["PI_notes"] as? String ?? "", date: caseType["date"] as? String ?? "", time: caseType["time"] as? String ?? "", status: caseType["status"] as? Bool ?? true )
                
                caseTypes.append(caseValue)
            }
            return caseTypes
        } catch let jsonError {
            print(jsonError)
        }
        return caseTypes
    }
    
    
    
    func parseCaseLiveStatusOptionsDataFromServer(JSONData: Data?) -> [CaseLiveStatus] {
        var caseLiveStatusOptions: [CaseLiveStatus] = []
        guard let data = JSONData else {
            return caseLiveStatusOptions
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let caseLiveStatusOptionsJson = json!["case_live_status_list"] as? [[String: String]] ?? []
            for caseLiveStatus in caseLiveStatusOptionsJson {
                let caseLiveStatusValue:CaseLiveStatus = CaseLiveStatus(id: caseLiveStatus["id"] ?? "", liveStatusDescription: caseLiveStatus["live_status_description"] ?? "", statusType: caseLiveStatus["status_type"] ?? "")
                caseLiveStatusOptions.append(caseLiveStatusValue)
            }
            return caseLiveStatusOptions
        } catch let jsonError {
            print(jsonError)
        }
        return caseLiveStatusOptions
    }
    
    
    func parseTipsDataFromServer(JSONData: Data?) -> [TipsForCaseType] {
        var tipslist: [TipsForCaseType] = []
        guard let data = JSONData else {
            return tipslist
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let tipsListJson = json!["tips_list"] as? [[String: String]] ?? []
            for tip in tipsListJson {
                let tipValue:TipsForCaseType = TipsForCaseType(tipId: tip["id"] ?? "", userRoleId: tip["user_type_id"] ?? "", tipDescription: tip["description"] ?? "", selected: false)
                tipslist.append(tipValue)
            }
            return tipslist
        } catch let jsonError {
            print(jsonError)
        }
        return tipslist
    }
    
    
    
    func parseRulesDataFromServer(JSONData: Data?) -> [RulesForCaseType] {
        var ruleslist: [RulesForCaseType] = []
        guard let data = JSONData else {
            return ruleslist
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let rulesListJson = json!["rules_list"] as? [[String: String]] ?? []
            for rule in rulesListJson {
                let ruleValue:RulesForCaseType = RulesForCaseType(ruleId: rule["id"] ?? "", userRoleId: rule["user_type_id"] ?? "", ruleDescription: rule["description"] ?? "", selected: false)
                ruleslist.append(ruleValue)
            }
            return ruleslist
        } catch let jsonError {
            print(jsonError)
        }
        return ruleslist
    }
    
    
    func parseTagsDataFromServer(JSONData: Data?) -> [String] {
        var tagslist: [String] = []
        guard let data = JSONData else {
            return tagslist
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let tagsListJson = json!["tags_list"] as? [[String: String]] ?? []
            for tag in tagsListJson {
                let tagValue:String = tag["tags"] ?? ""
                tagslist.append(tagValue)
            }
            return tagslist
        } catch let jsonError {
            print(jsonError)
        }
        return tagslist
    }
    
    
    
    
    func parseRegisterDataFromServer(JSONData: Data?) -> (String, String) {
        guard JSONData != nil else {
            return ("","")
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                let userid = jsonOutput["userId"] as! String
                let  msg = jsonOutput["success_msg"] as! String
                return (userid, msg)
            } else {
                let  msg = jsonOutput["err_msg"] as! String
                return ("", msg)
            }
        } catch let jsonError {
            print(jsonError)
        }
        return ("","")
    }
    
    
    func parseOTPVerificationDataFromServer(JSONData: Data?) -> (Bool, String) {
        guard JSONData != nil else {
            return (false,"")
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                let  msg = jsonOutput["success_msg"] as! String
                return (true, msg)
            } else {
                let  msg = jsonOutput["err_msg"] as! String
                return (false, msg)
            }
        } catch let jsonError {
            print(jsonError)
        }
        return (false,"")
    }
    
    
    func parseLoginDataFromServer(JSONData: Data?) -> (String,String,String,String) {
        guard JSONData != nil else {
            return ("","","","")
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                let userid = jsonOutput["userId"] as! String
                let roleid = jsonOutput["role_id"] as! String
                let phoneVerified = jsonOutput["login_verify"] as! String
                let  msg = jsonOutput["success_msg"] as! String
                return (userid, roleid, phoneVerified, msg)
            } else {
                let userid = jsonOutput["userId"] as? String ?? ""
                let roleid = jsonOutput["role_id"] as? String ?? ""
                let phoneVerified = jsonOutput["login_verify"] as? String ?? "false"
                let  msg = jsonOutput["err_msg"] as! String
                return (userid, roleid, phoneVerified, msg)
            }
        } catch let jsonError {
            print(jsonError)
        }
        return ("","","","")
    }
    
    
    func parseResendOTPDataFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    func parseUpdateUserDetailsFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    func parseGetUserProfileDetailsDataFromServer(JSONData: Data?) -> [String : String] {
        var userProfile: [String : String] = [:]
        guard let data = JSONData else {
            return userProfile
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let userJson = json!["user_profile"] as? [String: Any]
            let firstName:String = userJson!["first_name"] as? String ?? ""
            let lastName:String = userJson!["last_name"] as? String ?? ""
            let gender:String = userJson!["gender"] as? String ?? ""
            let dob:String = userJson!["dob"] as? String ?? ""
            let email:String = userJson!["email"] as? String ?? ""
            let phone:String = userJson!["mobile"]  as? String ?? ""
            let countryCode:String = userJson!["country_code"] as? String ?? ""
            let address:String = userJson!["address"] as? String ?? ""
            let street:String = userJson!["street"] as? String ?? ""
            let city:String = userJson!["city"] as? String ?? ""
            let state:String = userJson!["state"] as? String ?? ""
            let country:String = userJson!["country"] as? String ?? ""
            let zipcode:String = userJson!["zipcode"] as? String ?? ""
            let currentEmployer:String = userJson!["current_emp"] as? String ?? ""
            let equipment:String = userJson!["tag_your_equipment"] as? String ?? ""
            let latitude:String = userJson!["homeLatitude"] as? String ?? ""
            let longitude:String = userJson!["homeLongitude"] as? String ?? ""
            userProfile = ["FirstName": firstName, "LastName": lastName, "Gender": gender, "DOB" : dob, "GoogleID": "", "FacebookID": "", "Email": email, "Phone": phone, "Countrycode" : countryCode, "ProfilePicUrl" : "", "Address": address, "Street" : street, "City": city, "State": state, "Country" : country, "ZipCode" : zipcode, "CurrentEmployer" : currentEmployer, "EquipmentTags" : equipment, "Latitude" : latitude, "Longitude" : longitude]
            return userProfile
        } catch let jsonError {
            print(jsonError)
        }
        return userProfile
    }
    
    
    func parseCreateNewCaseBookerDataFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    
    
    func parseCaseListForBookerDataFromServer(JSONData: Data?) -> [CaseDetails] {
        var caselist: [CaseDetails] = []
        guard let data = JSONData else {
            return caselist
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let caseListArray = json!["case_list"] as? [[String: Any]] ?? []
                for casevalue in caseListArray {
                    let casedetails:CaseDetails = CaseDetails(id: casevalue["id"] as? String ?? "", booker_Id: casevalue["booker_Id"] as? String ?? "",privateeye_Id: "", case_type: casevalue["case_type"] as? String ?? "", person_of_interest: casevalue["person_of_interest"] as? String ?? "", poiAge: casevalue["age_of_POI"] as? String ?? "", poiGender: casevalue["gender_of_POI"] as? String ?? "", type_of_POI: casevalue["type_of_POI"] as? String ?? "", case_location_name: casevalue["case_location_name"] as? String ?? "", case_location_address: casevalue["case_location_address"] as? String ?? "", images_of_POI: casevalue["images_of_POI"] as? String ?? "", case_date: casevalue["case_date"] as? String ?? "", case_start_time: casevalue["case_start_time"] as? String ?? "", live_status_of_job: casevalue["live_status_of_job"] as? String ?? "", job_description: casevalue["job_description"] as? String ?? "", target_identification: casevalue["target_identification"] as? String ?? "", case_length: casevalue["case_length"] as? String ?? "", case_latitude: casevalue["case_latitude"] as? String ?? "0.0", case_longitude: casevalue["case_longitude"] as? String ?? "0.0", outcome_required: casevalue["outcome_required"] as? String ?? "")
                    caselist.append(casedetails)
                }
            return caselist
        } catch let jsonError {
            print(jsonError)
        }
        return caselist
    }
    
    
    func parseCaseListForPrivateEyeDataFromServer(JSONData: Data?) -> [CaseDetails] {
        var caselist: [CaseDetails] = []
        guard let data = JSONData else {
            return caselist
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let caseListArray = json!["case_list"] as? [[String: Any]] ?? []
            for casevalue in caseListArray {
                let casedetails:CaseDetails = CaseDetails(id: casevalue["id"] as? String ?? "", booker_Id: casevalue["booker_Id"] as? String ?? "", privateeye_Id: "", case_type: casevalue["case_type"] as? String ?? "", person_of_interest: casevalue["person_of_interest"] as? String ?? "", poiAge: casevalue["age_of_POI"] as? String ?? "", poiGender: casevalue["gender_of_POI"] as? String ?? "", type_of_POI: casevalue["type_of_POI"] as? String ?? "", case_location_name: casevalue["case_location_name"] as? String ?? "", case_location_address: casevalue["case_location_address"] as? String ?? "", images_of_POI: casevalue["images_of_POI"] as? String ?? "", case_date: casevalue["case_date"] as? String ?? "", case_start_time: casevalue["case_start_time"] as? String ?? "", live_status_of_job: casevalue["live_status_of_job"] as? String ?? "", job_description: casevalue["job_description"] as? String ?? "", target_identification: casevalue["target_identification"] as? String ?? "", case_length: casevalue["case_length"] as? String ?? "", case_latitude: casevalue["case_latitude"] as? String ?? "0.0", case_longitude: casevalue["case_longitude"] as? String ?? "0.0", outcome_required: casevalue["outcome_required"] as?String ?? "")
                caselist.append(casedetails)
            }
            return caselist
        } catch let jsonError {
            print(jsonError)
        }
        return caselist
    }
    
    
    
    func parseUpdateUserCurrentLocationFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    
    
    func parseUpdateUserFcmTokenStatusFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    
    
    func parseUpdateUserPhoneNumberVerificationStatusFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    
    func parseAcceptCaseStatusFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
    
    func parseUpdateCaseLiveStatusFeedDataFromServer(JSONData: Data?) -> Bool {
        guard JSONData != nil else {
            return false
        }
        do {
            let jsonOutput = try JSONSerialization.jsonObject(with: JSONData!, options:.mutableContainers) as! [String: Any]
            if jsonOutput["status"] as! Int == 1 {
                return true
            } else {
                return false
            }
        } catch let jsonError {
            print(jsonError)
        }
        return false
    }
    
}
