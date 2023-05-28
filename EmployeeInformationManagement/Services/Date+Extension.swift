//
//  Date+Extension.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/27/23.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return  dateFormatter.date(from:self)
    }
}
