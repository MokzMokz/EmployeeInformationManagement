//
//  EditEmployeeViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit

enum EditType {
    case add
    case edit
}

class EditEmployeeViewController: UIViewController {

    var employee: Employee?
    var company: Company?
    var type: EditType = .edit
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dateHired: UIDatePicker!
    @IBOutlet weak var dateDeparture: UIDatePicker!
    @IBOutlet weak var resignSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    private let employeeManager = EmployeeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        title = employee?.name ?? ""
        
        dateHired.semanticContentAttribute = .forceRightToLeft
        dateHired.subviews.first?.semanticContentAttribute = .forceRightToLeft
        dateDeparture.semanticContentAttribute = .forceRightToLeft
        dateDeparture.subviews.first?.semanticContentAttribute = .forceRightToLeft

        switch type {
        case .add:
            break
            //cancelButton.isHidden = false
        case .edit:
            //cancelButton.isHidden = true
            name.text = employee?.name
            resignSwitch.isOn = employee?.isActive ?? false
            dateDeparture.isEnabled = resignSwitch.isOn
            
            if let hired = employee?.hired.stringToDate() {
                dateHired.setDate(hired, animated: false)
            }
            if let departure = employee?.departure.stringToDate() {
                dateDeparture.setDate(departure, animated: false)
            }
        }
        
    }
    
    @IBAction func pressSaved(_ sender: Any) {
        switch type {
        case .add:
            if let company = company {
                var new = Employee()
                new.id = employeeManager.getNextID
                new.name = name.text ?? ""
                new.hired = dateHired.date.toString()
                new.departure = resignSwitch.isOn ? dateDeparture.date.toString() : ""
                new.active = resignSwitch.isOn ? 1 : 0
                new.company = company.name
                employeeManager.create(employee: new)
                self.dismiss(animated: true)
            }
        case .edit:
            if var employee = employee {
                employee.name = name.text ?? ""
                employee.hired = dateHired.date.toString()
                employee.departure = resignSwitch.isOn ? dateDeparture.date.toString() : ""
                employee.active = resignSwitch.isOn ? 1 : 0
                employeeManager.update(employee: employee)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func pressSwitch(_ sender: UISwitch) {
        dateDeparture.isEnabled = sender.isOn
    }
}
