//
//  Employee.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

struct Employee: Codable {
    
//    "name": "Afghanistan",
//    "hired": "02/02/2022",
//    "departure": "AF"
//    "active": 0
//    "company": "Google"
    
    var id: Int = 0
    var name: String = ""
    var hired: String = ""
    var departure: String = ""
    var active: Int = 0
    var company: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case hired
        case departure
        case active
        case company
    }
}

extension Employee {
    
    var getDate: Date? {
        return Date()
    }
    
    var isActive: Bool {
        return active == 1
    }
}
