//
//  ViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedLoginButton(_ sender: Any) {
        if  let userName = userName.text,
            let password = password.text {
            if let company = viewModel.processLogin(userName: userName, password: password) {
                self.navigationRouter.presentEmployee(company: company)
            } else {
                self.showAlert(message: Strings.Dialog.incorrect, showCancel: false)
               
            }
        }
    }
    
    
}

