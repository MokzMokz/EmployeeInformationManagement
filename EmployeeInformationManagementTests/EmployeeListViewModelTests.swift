//
//  EmployeeListViewModelTests.swift
//  EmployeeInformationManagementTests
//
//  Created by phmacr on 5/28/23.
//

import XCTest
import RxSwift

final class EmployeeListViewModelTests: XCTestCase {
    private var viewModel: EmployeeListViewModel?
    
    override func setUp() {
        viewModel = EmployeeListViewModel(employeeManager: EmployeeManager.shared)
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_setupData() {
        XCTAssertNoThrow(viewModel?.initialize())
        
        let company = Company(name: "Collabera", username: "Collabera", password: "Collabera")
        XCTAssertNoThrow(viewModel?.setUpData(company: company))
    }
}
