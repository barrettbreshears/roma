//
//  AccountExtension.swift
//  mastodon
//
//  Created by Barrett Breshears on 12/7/18.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation


extension Account: Equatable {
    
    static func addAccountToList(account:Account) {
        
        guard let accountsData = UserDefaults.standard.object(forKey: "allAccounts") as? Data, var accounts = try? PropertyListDecoder().decode(Array<Account>.self, from: accountsData) else {
            let accounts = [account]
            UserDefaults.standard.set(try? PropertyListEncoder().encode(accounts), forKey:"allAccounts")
            return
        }
        
        if !accounts.contains(account) {
            accounts.append(account)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(accounts), forKey:"allAccounts")
        }
        
    }
    
    static func getAccounts() -> [Account] {
        
        guard let accountsData = UserDefaults.standard.object(forKey: "allAccounts") as? Data, let accounts = try? PropertyListDecoder().decode(Array<Account>.self, from: accountsData) else {
            return [Account]()
        }
        return accounts
        
    }
    
    static func clearAccounts() {
        UserDefaults.standard.setValue(nil, forKey: "allAccounts")
    }
    
    static public func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.username == rhs.username && lhs.id == rhs.id
    }
    
}
