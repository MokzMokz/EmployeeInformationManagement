//
//  LoginViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxRelay

class LoginViewModel: LoginProtocol {
    var loginCompany: BehaviorRelay<Company?> = BehaviorRelay(value: nil)
    var loginManager: LoginManagerSource?
    weak var loginCoordinatorDelegate: LoginCoordinatorDelegate?
    
    init(loginManager: LoginManagerSource) {
        self.loginManager = loginManager
    }
    
    func processLogin(userName: String, password: String) {
        if let result = loginManager?.processLogin(userName: userName, password: password) {
            loginCompany.accept(result)
        } else {
            loginCompany.accept(nil)
        }
    }
}
