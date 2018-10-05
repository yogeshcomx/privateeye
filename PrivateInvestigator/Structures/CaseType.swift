//
//  CaseType.swift
//  PrivateInvestigator
//
//  Created by apple on 7/10/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation
import UIKit

struct CaseType: Decodable {
    let id:String
    let case_type:String
    let min_length_with_travel:String
    let min_notice:String
    let distance_limit:String
    let equipment_set:String
    let actions:String
    let mandatory:String
    let more_than_one_target:Bool
    let persuit_by_car:Bool
    let booker_notes:String
    let PI_notes:String
    let date:String
    let time:String
    let status:Bool
}

struct CaseTime {
    let title:String
    let minutes:Int 
}

struct TipsForCaseType {
    let tipId:String
    let userRoleId:String
    let tipDescription:String
    var selected:Bool = false
}

struct RulesForCaseType {
    let ruleId:String
    let userRoleId:String
    let ruleDescription:String
    var selected:Bool = false
}


struct CaseLiveStatus {
    let id:String
    let liveStatusDescription:String
    let statusType:String
}


struct CaseDetails: Decodable {
    
    let id:String
    let booker_Id:String
    let privateeye_Id:String
    let case_type:String
    let person_of_interest:String
    let poiAge:String
    let poiGender:String
    let type_of_POI:String
    let case_location_name:String
    let case_location_address:String
    let images_of_POI:String
    let case_date:String
    let case_start_time:String
    let live_status_of_job:String
    let job_description:String
    let target_identification:String
    let case_length:String
    let case_latitude:String
    let case_longitude:String
    let outcome_required:String
}
