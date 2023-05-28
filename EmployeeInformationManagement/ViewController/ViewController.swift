//
//  ViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

  
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    let viewModel = ViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addObservers()
    }

    private func addObservers() {
        viewModel.loginCompany.subscribe { company in
            if let company = company {
                self.navigationRouter.presentEmployee(company: company)
            } else {
                self.showAlert(message: Strings.Dialog.incorrect, showCancel: false)
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        if  let userName = userName.text,
            let password = password.text {
            viewModel.processLogin(userName: userName, password: password)
        }
    }
}

