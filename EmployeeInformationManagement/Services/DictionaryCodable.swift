//
//  DictionaryCodable.swift
//  EmployeeInformationManagement
//
//  Created by phmacr on 5/26/23.
//

import Foundation

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()
    
    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
    
    static func stringResponse<T>(_ response: [T]) -> String? where T: Codable {
        do {
            if let dict = dictionaryResponse(response) {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    return jsonString
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func dictionaryResponse<T>(_ response: [T]) -> [[String: Any]]? where T: Codable {
        do {
            let dictionaryResp = try DictionaryEncoder().encode(response)
            if let resp = dictionaryResp as? [[String: Any]] {
                return resp
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()
    
    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
