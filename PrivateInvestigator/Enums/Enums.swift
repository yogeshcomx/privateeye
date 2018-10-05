//
//  Enums.swift
//  PrivateInvestigator
//
//  Created by apple on 6/20/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation

enum Gender: String {
    case Male
    case Female
    case None
}

enum GenderPOI: String {
    case Male
    case Female
    case Group
    case None
}


enum CaseStatusBooker: String {
    case Created
    case Accepted
    case Closed
}


enum CaseStatusPrivateEye: String {
    case WaitingForAcceptance
    case Accepted
    case Closed
    case None
}

enum FileType: String {
    case Image
    case Video
    case Doc
    case None
}
