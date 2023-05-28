//
//  EmployeeListViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxRelay
class EmployeeListViewModel: NSObject {
    
    private let employeeManager = EmployeeManager.shared
   
    func setUpData(company: Company) {
        employeeManager.fetch(name: company.name)
    }
}
