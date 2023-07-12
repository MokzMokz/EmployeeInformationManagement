//
//  EditEmployeeCoordinator.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import UIKit

class EditEmployeeCoordinator: Coordinator {
    private var employee: Employee?
    
    init(employee: Employee? = nil) {
        self.employee = employee
    }
    
    func start() -> UIViewController {
        let editEmployeeVC = EditEmployeeCoordinator.instantiateViewController() as! EditEmployeeViewController
        editEmployeeVC.employee = employee
        let viewModel = EditEmployeeViewModel(employeeManager: EmployeeManager.shared)
        editEmployeeVC.viewModel = viewModel
        return editEmployeeVC
    }
}

extension EditEmployeeCoordinator : StoryboardInitializable {
    static var storyboardName: UIStoryboard.Storyboard {
        return .main
    }
}
