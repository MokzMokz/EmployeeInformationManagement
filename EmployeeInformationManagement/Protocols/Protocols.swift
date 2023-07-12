//
//  Protocols.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import Foundation
import UIKit

protocol EmployeeManagerSource: AnyObject {
    func initalize()
    func create(employee: Employee)
    func update(employee: Employee)
    func delete(employee: Employee)
    @discardableResult func fetch(company id: Int) -> [Employee]?
    func saveToJsonFile()
}

protocol LoginProtocol: AnyObject {
    func processLogin(userName: String, password: String)
}

protocol LoginCoordinatorDelegate: AnyObject {
    func gotoEmployeeList(with company: Company)
}

protocol EmployeeListProtocol: AnyObject {
    func initialize()
    func setUpData(company: Company)
}

protocol EmployeeListCoordinatorDelegate: AnyObject {
    func editEmployee(with employee: Employee)
    func addEmployee()
}

protocol EditEmployeeListProtocol: AnyObject {
    func processUpdate(employee: Employee, type: EditType)
}

/**
 For initializeing story board and instantiaing ViewController .
 
 - storyboardIdentifier : Should be same as class name
 - storyboardName : storyboard enum
 - instantiateViewController : for instantiating viewcontroller
 */
protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
    static var storyboardName: UIStoryboard.Storyboard { get }
    static func instantiateViewController() -> UIViewController
}
