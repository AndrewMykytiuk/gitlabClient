//
//  KeychainService.swift
//  GitlabClient
//
//  Created by User on 19/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation


class KeychainItem {
    
      func readToken() -> Result<String>  {
        
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) 
        }
        
        guard status != errSecItemNotFound else {
            return .error(KeychainError.noPassword(errSecItemNotFound.description)) }
        guard status == noErr else { return .error(KeychainError.unhandledError(noErr.description))  }
        
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else { return .error(KeychainError.unexpectedPasswordString(queryResult?.description)) }
        
        return .success(password)
    }
    
    func saveToken(_ password: String) -> Result<Void> {
        
        guard let passwordData = password.data(using: String.Encoding.utf8) else {
            return .error(KeychainError.noPassword(password.description))
        }
        
        let result = readToken()
        
        switch result {
        case .success:
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject?
            
            var query = [String : AnyObject]()
            query[kSecClass as String] = kSecClassGenericPassword
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { return .error(KeychainError.unhandledError(noErr.description))}
            return .success(Void())
            
        case .error:
            var newItem = [String : AnyObject]()
            newItem[kSecClass as String] = kSecClassGenericPassword
            newItem[kSecValueData as String] = passwordData as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { return .error(KeychainError.unhandledError(noErr.description))}
            return .success(Void())
        }
    }
    
    func removeToken(_ password: String) -> Result<Void> {
        
        guard let passwordData = password.data(using: String.Encoding.utf8) else {
            return .error(KeychainError.noPassword(password.description))
        }
        
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecValueData as String] = passwordData as AnyObject?
        
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr else { return .error(KeychainError.unhandledError(noErr.description))}
        
        return .success(Void())
    }
    
}
