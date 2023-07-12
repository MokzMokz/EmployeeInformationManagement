//
//  LoginManager.swift
//  EmployeeInformationManagement
//
//  Created by Collabera on 7/12/23.
//

import UIKit

protocol LoginManagerSource: AnyObject {
    func getAllLoginData()
    func processLogin(userName: String, password: String) -> Company?
}

class LoginManager: LoginManagerSource {
    static let shared = LoginManager()
    var companyList = [Company]()
    
    
    init() {
        getAllLoginData()
    }
    
    func getAllLoginData(){
        let data = File.generate(dictionaryFromFile: "company")
        guard let companies = try? DictionaryDecoder().decode([Company].self, from: data) else {
            companyList.removeAll()
            return
        }
        companyList = companies
    }
    
    func processLogin(userName: String, password: String) -> Company? {
        guard let result = companyList.first(where: {
            $0.credentials?.username == userName && $0.credentials?.password == password
        }) else {
            return nil
        }
        
        return result
    }
}
