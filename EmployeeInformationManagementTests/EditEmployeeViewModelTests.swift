//
//  EditEmployeeViewModelTests.swift
//  EmployeeInformationManagementTests
//
//  Created by phmacr on 5/28/23.
//

import XCTest

final class EditEmployeeViewModelTests: XCTestCase {

    private var viewModel: EditEmployeeViewModel?
    private let employeeManager = EmployeeManager.shared
    
    override func setUp() {
        viewModel = EditEmployeeViewModel(employeeManager: employeeManager)
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_add() {
        var employee = Employee()
        employee.id = employeeManager.getNextID
        employee.name = "FIRST NAME, LAST NAME"
        employee.hired = "10/22/23"
        employee.departure = ""
        employee.active = 0
        employee.company = "COMPANY"
        XCTAssertNoThrow(viewModel?.processUpdate(employee: employee, type: .add))
    }
    
    func test_update() {
        if let list = viewModel?.employeeManager?.fetch(name: "COMPANY"),
           var employee = list.first {
            employee.name = "UPDATED NAME"
            XCTAssertNoThrow(viewModel?.processUpdate(employee: employee, type: .edit))
            XCTAssertTrue(list.count != 0)
        }
    }
}
