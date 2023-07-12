//
//  EmployeeListViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxRelay
class EmployeeListViewModel: EmployeeListProtocol {
    weak var employeeManager: EmployeeManagerSource?
    weak var employeeListCoordinatorDelegate: EmployeeListCoordinatorDelegate?
    
    init(employeeManager: EmployeeManagerSource) {
        self.employeeManager = employeeManager
    }
    
    func initialize() {
        employeeManager?.initalize()
    }
    
    func setUpData(company: Company) {
        employeeManager?.fetch(company: company.id)
    }
}
