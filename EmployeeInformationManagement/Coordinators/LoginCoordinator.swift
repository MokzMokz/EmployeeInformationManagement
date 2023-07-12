//
//  LoginCoordinator.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import UIKit
import Foundation

class LoginCoordinator: Coordinator {
    weak var rootViewController: UIViewController!
    var employeeListCoordinator : EmployeeListCoordinator!
    
    func start() -> UIViewController {
        let loginVC = LoginCoordinator.instantiateViewController() as! LoginViewController
        rootViewController = loginVC
        let viewModel = LoginViewModel(loginManager: LoginManager.shared)
        viewModel.loginCoordinatorDelegate = self
        loginVC.viewModel = viewModel
        return loginVC
    }
}

extension LoginCoordinator: LoginCoordinatorDelegate {
    func gotoEmployeeList(with company: Company) {
        employeeListCoordinator = EmployeeListCoordinator(company: company)
        let employeeListVC = employeeListCoordinator.start()
        rootViewController.present(employeeListVC, animated: true)
    }
}

extension LoginCoordinator : StoryboardInitializable {
    static var storyboardName: UIStoryboard.Storyboard {
        return .main
    }
}
