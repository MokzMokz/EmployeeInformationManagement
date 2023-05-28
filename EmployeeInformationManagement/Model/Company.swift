//
//  Company.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

struct Company: Codable {
    var name: String = ""
    var username: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "company_name"
        case username
        case password
    }
}
