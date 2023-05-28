//
//  EditEmployeeViewController.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit

class EditEmployeeViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dateHired: UIDatePicker!
    @IBOutlet weak var dateDeparture: UIDatePicker!
    @IBOutlet weak var resignSwitch: UISwitch!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var employee: Employee?
    var company: Company?
    var type: EditType = .edit
    lazy var cancel: UIBarButtonItem = {
        let cancel = UIBarButtonItem(title: Strings.Buttons.cancel, style: .plain, target: self, action: #selector(pressCancel))
        return cancel
    }()
    
    private let employeeManager = EmployeeManager.shared
    private let viewModel = EditEmployeeViewModel(employeeManager: EmployeeManager.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeBackButtonTitle()
        setupUI()
    }
    
    private func setupUI() {
        title = employee?.name ?? ""
        removeBackButtonTitle()
        
        dateHired.semanticContentAttribute = .forceRightToLeft
        dateHired.subviews.first?.semanticContentAttribute = .forceRightToLeft
        dateDeparture.semanticContentAttribute = .forceRightToLeft
        dateDeparture.subviews.first?.semanticContentAttribute = .forceRightToLeft

        switch type {
        case .add:
            navigationItem.leftBarButtonItem = cancel
        case .edit:
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
                var employee = Employee()
                employee.id = employeeManager.getNextID
                employee.name = name.text ?? ""
                employee.hired = dateHired.date.toString()
                employee.departure = resignSwitch.isOn ? dateDeparture.date.toString() : ""
                employee.active = resignSwitch.isOn ? 1 : 0
                employee.companyID = company.id
                viewModel.processUpdate(employee: employee, type: type)
                self.dismiss(animated: true)
            }
        case .edit:
            if var employee = employee {
                employee.name = name.text ?? ""
                employee.hired = dateHired.date.toString()
                employee.departure = resignSwitch.isOn ? dateDeparture.date.toString() : ""
                employee.active = resignSwitch.isOn ? 1 : 0
                viewModel.processUpdate(employee: employee, type: type)
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
