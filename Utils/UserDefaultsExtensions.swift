//
//  UserDefaultsExtensions.swift
//  ABTest
//
//  Created by ripple_k on 2018/7/24.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

extension UserDefaults {
    func set<T: Codable>(object: T, forKey: String) {
        let jsonData = try? JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    func get<T: Codable>(objectType: T.Type, forKey: String) -> T? {
        guard let reuslt = value(forKey: forKey) as? Data else {
            return nil
        }
        let result = try? JSONDecoder().decode(objectType, from: reuslt)
        return result
    }
}
