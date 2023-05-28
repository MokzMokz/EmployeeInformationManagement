//
//  ViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit

class ViewModel: NSObject {
    var companyList = [Company]()
    
    override init() {
        super.init()
        setUpData()
    }
    
    func setUpData() {
        let data = File.generate(dictionaryFromFile: "company")
        guard let companies = try? DictionaryDecoder().decode([Company].self, from: data) else {
            return
        }
        
        companyList = companies
    }
    
    func processLogin(userName: String, password: String) -> Company? {
        if let result = companyList.first(where: { company in
            company.username == userName && company.password == password
        }){
            return result
        }
        return nil
    }
    
}
