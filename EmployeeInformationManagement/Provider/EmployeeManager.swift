//
//  EmployeeManager.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxSwift
import RxRelay

protocol EmployeeManagerSource: AnyObject {
    func initalize()
    func create(employee: Employee)
    func update(employee: Employee)
    func delete(employee: Employee)
    @discardableResult func fetch(name: String) -> [Employee]?
    func saveToJsonFile()
}

class EmployeeManager: EmployeeManagerSource {
    static let shared = EmployeeManager()
    private let fileManager = FileManager.default
    var list: BehaviorRelay<[Employee]> = BehaviorRelay(value: [])
    
    var all = [Employee]()
    var employeeList = [Employee]() {
        didSet {
            list.accept(employeeList)
        }
    }
    
    func initalize() {
        let data = File.generateFromDirectory(dictionaryFromFile: Strings.FileNames.employee)
        if let companies = try? DictionaryDecoder().decode([Employee].self, from: data) {
            //employeeList = companies.sorted(by: { $0.id > $1.id })
            all = companies.sorted(by: { $0.id > $1.id })
        }
    }
    
    func create(employee: Employee) {
        employeeList.append(employee)
        all.append(employee)
        saveToJsonFile()
    }
    
    func update(employee: Employee) {
        if let index = employeeList.firstIndex(where: { $0.id == employee.id }) {
            employeeList[index] = employee
            saveToJsonFile()
        }
        if let index = all.firstIndex(where: { $0.id == employee.id }) {
            all[index] = employee
        }
    }
    
    func delete(employee: Employee) {
        if let index = employeeList.firstIndex(where: { $0.id == employee.id }) {
            employeeList.remove(at: index)
            saveToJsonFile()
        }
        if let index = all.firstIndex(where: { $0.id == employee.id }) {
            employeeList.remove(at: index)
        }
    }
    
    @discardableResult func fetch(name: String) -> [Employee]? {
        let filteredEmployees = all.filter { $0.company == name }
        employeeList = filteredEmployees
        
        return filteredEmployees
    }
    
    func saveToJsonFile() {
        if let content = DictionaryEncoder.stringResponse(all) {
            File.saveFile(content: content, fileName: Strings.FileNames.employee)
        }
    }
    
    var getNextID: Int {
        let data = File.generateFromDirectory(dictionaryFromFile: Strings.FileNames.employee)
        if let companies = try? DictionaryDecoder().decode([Employee].self, from: data) {
            let count = companies.count
            return count + 1
        }
        return 0
    }
}
