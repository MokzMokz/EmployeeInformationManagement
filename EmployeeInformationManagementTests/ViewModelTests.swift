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
        XCTAssertNoThrow(viewModel?.processLogin(userName: "Collabera", password: "Collabera"))
    }

}
