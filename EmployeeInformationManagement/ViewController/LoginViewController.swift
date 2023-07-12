//
//  LoginViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

  
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    var viewModel: LoginViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addObservers()
    }

    private func addObservers() {
        viewModel?.loginCompany.subscribe { [weak self] company in
            if let company = company {
                self?.viewModel?.loginCoordinatorDelegate?.gotoEmployeeList(with: company)
            } else {
                self?.showAlert(message: Strings.Dialog.incorrect, showCancel: false)
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        if  let userName = userName.text,
            let password = password.text {
            viewModel?.processLogin(userName: userName, password: password)
        }
    }
}

