//
//  EmployeeTableViewCell.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hired: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var resignSwitch: UISwitch!
    
    var employee: Employee? {
        didSet {
            setupViews()
        }
    }
    
    func setupViews() {
        name.text = employee?.name
        hired.text = "Hired: \(employee?.hired ?? "")"
        departure.text = "Departure: \(employee?.departure ?? "")"
        resignSwitch.isOn = employee?.active == 1
    }
}
