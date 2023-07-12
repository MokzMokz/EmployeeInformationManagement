//
//  EditEmployeeViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/28/23.
//

import UIKit

enum EditType {
    case add
    case edit
}

class EditEmployeeViewModel: EditEmployeeListProtocol {

    weak var employeeManager: EmployeeManagerSource?
    
    init(employeeManager: EmployeeManagerSource) {
        self.employeeManager = employeeManager
    }
    
    func processUpdate(employee: Employee, type: EditType) {
        switch type {
        case .add:
            employeeManager?.create(employee: employee)
        case .edit:
            employeeManager?.update(employee: employee)
        }
    }
}
