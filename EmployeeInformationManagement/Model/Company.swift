//
//  Company.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

struct Company: Codable {
    var id: Int = 0
    var name: String = ""
    var credentials: Credentials?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "company_name"
        case credentials
    }
}

struct Credentials: Codable {
    var username: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
