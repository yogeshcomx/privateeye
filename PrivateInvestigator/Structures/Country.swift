//
//  Country.swift
//  PrivateInvestigator
//
//  Created by apple on 6/28/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let id:String
    let country_name:String
    let country_code:String
}

/*
import Foundation

struct Contact: Decodable {
    struct geoInfo:Decodable {
        let lat: String
        let lng: String
    }
    
    struct addressInfo: Decodable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: geoInfo
    }
    struct companyInfo: Decodable {
        let name: String
        let catchPhrase:String
        let bs: String
    }
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: addressInfo
    let phone: String
    let website: String
    let company: companyInfo
    
}

 */
