//
//  Employee.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

struct Employee: Codable {
    var id: Int = 0
    var name: String = ""
    var hired: String = ""
    var departure: String = ""
    var active: Int = 0
    var companyID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case hired
        case departure
        case active
        case companyID = "company_id"
    }
}

extension Employee {
    var isActive: Bool {
        return active == 1
    }
}
