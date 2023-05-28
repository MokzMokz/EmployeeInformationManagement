//
//  ViewModelTests.swift
//  EmployeeInformationManagementTests
//
//  Created by phmacr on 5/28/23.
//

import XCTest

final class ViewModelTests: XCTestCase {

    private var viewModel: ViewModel?
    
    override func setUp() {
        viewModel = ViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func test_setupData() {
        viewModel?.loginCompany.subscribe(onNext: { company in
            XCTAssertNil(company)
        }).dispose()
        
        viewModel?.processLogin(userName: "collabera", password: "collabera")
        
        viewModel?.loginCompany.subscribe(onNext: { company in
            XCTAssertNotNil(company)
            XCTAssertEqual(company?.name, "COLABERRA")
        }).dispose()
    }

}
