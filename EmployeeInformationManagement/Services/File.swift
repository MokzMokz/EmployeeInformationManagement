//
//  File.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

struct File {
    static func generate(dictionaryFromFile jsonFile: String) -> Any {
        guard  let path = Bundle.main.path(forResource: jsonFile, ofType: "json"),
               let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return [:]
        }
        
        return jsonString.toResponse()
    }
    
    static func generateFromDirectory(dictionaryFromFile jsonFile: String) -> Any {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(jsonFile)
        
        guard  let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            return [:]
        }
        
        return jsonString.toResponse()
    }
    
    static func saveFile(content: String, fileName: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let textFileUrl = documentDirectory.appendingPathComponent(fileName)
        
        // write text
        do {
            try content.write(to: textFileUrl, atomically: false, encoding: .utf8)
        } catch let error {
            print("error -- \(error)")
        }
    }
}

extension String {
    func toResponse() -> Any {
        guard let data = self.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return [:]
        }
        
        return dictionary
    }
}
