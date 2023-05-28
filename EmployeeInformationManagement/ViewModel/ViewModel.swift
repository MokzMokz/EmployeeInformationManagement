//
//  ViewModel.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import UIKit
import RxRelay

class ViewModel: NSObject {
    var companyList = [Company]()
    var loginCompany: BehaviorRelay<Company?> = BehaviorRelay(value: nil)
    
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
    
    func processLogin(userName: String, password: String) {
        guard let result = companyList.first(where: {
            $0.credentials?.username == userName && $0.credentials?.password == password
        }) else {
            loginCompany.accept(nil)
            return
        }
        
        loginCompany.accept(result)
    }
}
