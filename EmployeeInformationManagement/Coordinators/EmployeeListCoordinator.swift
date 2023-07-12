//
//  EmployeeListCoordinator.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import UIKit
import Foundation

class EmployeeListCoordinator: Coordinator {
    private let company: Company?
    private var editEmployeeCoordinator : EditEmployeeCoordinator!
    private var navigationController: UINavigationController!
    
    init(company : Company) {
        self.company = company
    }
    
    func start() -> UIViewController {
        let employeeListVC = EmployeeListCoordinator.instantiateViewController() as! EmployeeListViewController
        navigationController = UINavigationController(rootViewController: employeeListVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        let viewModel = EmployeeListViewModel(employeeManager: EmployeeManager.shared)
        employeeListVC.viewModel = viewModel
        employeeListVC.viewModel?.employeeListCoordinatorDelegate = self
        return navigationController
    }
}

extension EmployeeListCoordinator: EmployeeListCoordinatorDelegate {
    func editEmployee(with employee: Employee) {
        editEmployeeCoordinator = EditEmployeeCoordinator(employee: employee)
        let employeeListVC = editEmployeeCoordinator.start()
        navigationController.pushViewController(employeeListVC, animated: true)
    }
    
    func addEmployee() {
        editEmployeeCoordinator = EditEmployeeCoordinator()
        if let employeeListVC = editEmployeeCoordinator.start() as? EditEmployeeViewController {
            employeeListVC.type = .add
            let nav  = UINavigationController(rootViewController: employeeListVC)
            nav.modalPresentationStyle = .fullScreen
            navigationController.present(nav, animated: true)
        }
    }
}

extension EmployeeListCoordinator : StoryboardInitializable {
    static var storyboardName: UIStoryboard.Storyboard {
        return .main
    }
}
