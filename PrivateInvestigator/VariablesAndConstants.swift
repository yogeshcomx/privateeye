//
//  VariablesAndConstants.swift
//  PrivateInvestigator
//
//  Created by apple on 7/10/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation
import UIKit

//Arrays
var caseTypesListGlobal:[CaseType] = []
var countriesListGlobal:[Country] = []
var tipsListGlobal:[TipsForCaseType] = []
var rulesListGlobal:[RulesForCaseType] = []
var caseLiveStatusFeedOptionsGlobal:[CaseLiveStatus] = []
var caseTimeValuesGlobal: [CaseTime] = [CaseTime(title:"15 minutes", minutes:15),CaseTime(title:"30 minutes", minutes:30),CaseTime(title:"1 hour", minutes:60),CaseTime(title:"2 hours", minutes:120),CaseTime(title:"4 hours", minutes:240),CaseTime(title:"8 hours", minutes:480),CaseTime(title:"12 hours", minutes:720),CaseTime(title:"1 day", minutes:1440),CaseTime(title:"2 days", minutes:2880)]
var POITypesListGlobal: [String] = ["Your Male Partner", "Your Female Partner", "Teenager - Male", "Teenager - Female", "Staff member - Male", "Staff member - Female", "Group of people", "Other - further specify", "N/A"]
var caseOutcomeListGlobal: [String] = ["Picture or Video", "File upload", "Proof (Evidence gathered)", "Witness and document", "Record voice", "Take notes on movement"]
var ageRangeListGlobal : [String] = ["15 - 24", "25 - 34", "35 - 60", "61 and above"]
var liveStatusFeedOptions: [String] = ["Cant locate target (still looking)", "Target Located - Unsuspicious - time to be registered for testimony", "Target on the move - Unable to follow", "Target is aware of me watching", "Target is acting suspicious", "Target is on the move - Following", "Last status sent in error", "Permission to extend time"]

//Double
var currentLatitude:Double?
var currentLongitude:Double?



