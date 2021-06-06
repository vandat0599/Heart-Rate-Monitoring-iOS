//
//  UserDefaultHelper.swift
//  Heart Rate Monitor
//
//  Created by Dat Van on 04/05/2021.
//

import Foundation

class UserDefaultHelper {
    
    enum Key: String {
        case openCount
        case deviceToken
        case loggedInAccount
        case userPassword
        case openCalmCount
        case openMonitorCount
        case accessToken
        
        // setting key
        case basicInfomation
        case weight
        case flash
        case sensitivity
        case heartWaves
        case measurementTime
        case sound
        case exportHistory
    }
    
    private static let defaults = UserDefaults.standard
    private static let jsonDecoder = JSONDecoder()
    private static let jsonEncoder = JSONEncoder()
    
    static func getLogedUser() -> User? {
        return getCodableObject(key: .loggedInAccount)
    }
    
    static func get(key: Key) -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    static func save(value: Any?, key: Key, async: Bool = false) {
        switch async {
        case true:
            let queue = DispatchQueue(label: "UserDefault")
            queue.async {
                defaults.set(value, forKey: key.rawValue)
            }
        case false:
            defaults.set(value, forKey: key.rawValue)
        }
    }
    
    static func remove(key: Key, async: Bool = false) {
        switch async {
        case true:
            let queue = DispatchQueue(label: "UserDefault")
            queue.async {
                defaults.removeObject(forKey: key.rawValue)
            }
        case false:
            defaults.removeObject(forKey: key.rawValue)
        }
    }
    
    // MARK: - Codable Object
    // If object has already exist, it will be overwrited
    static func saveCodableObject<T: Codable>(_ item: T, key: Key, async: Bool = false) {
        if let jsonData = try? jsonEncoder.encode(item) {
            self.save(value: jsonData, key: key, async: async)
            print("Saved \(jsonData)")
        } else {
            print("Cannot save \(item) to UserDefault")
        }
    }
    
    static func getCodableObject<T: Codable>(key: Key) -> T? {
        if let jsonData = get(key: key) as? Data {
            return try? jsonDecoder.decode(T.self, from: jsonData)
        }
        return nil
    }
    
    // MARK: - Codable Array
    // If array has already exist, it will be overwrited
    static func saveCodableArray<T: Codable>(_ array: [T], key: Key, async: Bool = false) {
        if let jsonData = try? jsonEncoder.encode(array) {
            self.save(value: jsonData, key: key, async: async)
        } else {
            print("Cannot save \(array) to UserDefault")
        }
    }
    
    static func getCodableArray<T: Codable>(key: Key) -> [T]? {
        if let jsonData = get(key: key) as? Data {
            return try? jsonDecoder.decode([T].self, from: jsonData)
        }
        return nil
    }
}
