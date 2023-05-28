//
//  ViewController+Alert.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation
import UIKit

extension UIViewController {
    func removeBackButtonTitle() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func showAlert(withTitle title: String = "",
                   message: String,
                   cancelTitle: String = "Cancel",
                   actionTitle: String = "OK",
                   showCancel: Bool = true,
                   actionTitleStyle: UIAlertAction.Style = .default, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if showCancel {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default))
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: actionTitleStyle, handler: { (action) in
            completion?()
        }))
        present(alert, animated: true)
    }
}
