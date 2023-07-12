//
//  EmployeeManager.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxSwift
import RxRelay

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
        all.removeAll()
        employeeList.removeAll()
        let data = File.generateFromDirectory(dictionaryFromFile: Strings.FileNames.employee)
        if let companies = try? DictionaryDecoder().decode([Employee].self, from: data) {
            all = companies.sorted(by: { $0.id > $1.id })
        }
    }
    
    func create(employee: Employee) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.employeeList.append(employee)
            self?.all.append(employee)
            self?.saveToJsonFile()
        }
    }
    
    func update(employee: Employee) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let index = self?.employeeList.firstIndex(where: { $0.id == employee.id }) {
                self?.employeeList[index] = employee
            }
            if let index = self?.all.firstIndex(where: { $0.id == employee.id }) {
                self?.all[index] = employee
                self?.saveToJsonFile()
            }
        }
    }
    
    func delete(employee: Employee) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let index = self?.employeeList.firstIndex(where: { $0.id == employee.id }) {
                self?.employeeList.remove(at: index)
            }
            if let index = self?.all.firstIndex(where: { $0.id == employee.id }) {
                self?.all.remove(at: index)
                self?.saveToJsonFile()
            }
        }
    }
    
    @discardableResult func fetch(company id: Int) -> [Employee]? {
        let filteredEmployees = all.filter { $0.companyID == id }
        employeeList = filteredEmployees
        
        return filteredEmployees
    }
    
    func saveToJsonFile() {
        if let content = DictionaryEncoder.stringResponse(all) {
            File.saveFile(content: content, fileName: Strings.FileNames.employee)
        }
    }
    
    var getNextID: Int {
        if !all.isEmpty {
            return all.count + 1
        }
        return 0
    }
}
