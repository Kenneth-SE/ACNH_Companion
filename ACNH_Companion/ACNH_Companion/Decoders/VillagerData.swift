//
//  VillagerData.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/21/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Decodes the villager API call
class VillagerData: NSObject, Decodable {
    // General data
    var id: Int32?
    var personality: String?
    var birthdayStr: String?
    var birthday: String?
    var species: String?
    var gender: String?
    var catchPhrase: String?
    
    // Name
    var name: String?

    // Root keys
    private enum VillagerKeys: String, CodingKey {
        case id
        case name
        case personality
        case birthdayStr = "birthday-string"
        case birthday
        case species
        case gender
        case catchPhrase = "catch-phrase"
    }
    
    // Name container keys
    private enum nameKeys: String, CodingKey {
        case nameEN = "name-USen"
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: VillagerKeys.self)
        let nameContainer = try? rootContainer.nestedContainer(keyedBy: nameKeys.self, forKey: .name)
        
        // MARK: - General data
        
        // Decode villager ID
        if let villagerID = try? rootContainer.decode(Int32.self, forKey: .id) {
            id = villagerID
        }
        
        // Decode villager personality
        if let villagerPersonality = try? rootContainer.decode(String.self, forKey: .personality) {
            personality = villagerPersonality
        }
        
        // Decode villager birthday string
        if let villagerBirthdayString = try? rootContainer.decode(String.self, forKey: .birthdayStr) {
            birthdayStr = villagerBirthdayString
        }
        
        // Decode villager birthday
        if let villagerBirthday = try? rootContainer.decode(String.self, forKey: .birthday) {
            birthday = villagerBirthday
        }
        
        // Decode villager species
        if let villagerSpecies = try? rootContainer.decode(String.self, forKey: .species) {
            species = villagerSpecies
        }
        
        // Decode villager gender
        if let villagerGender = try? rootContainer.decode(String.self, forKey: .gender) {
            gender = villagerGender
        }
        
        // Decode villager catch-phrase
        if let villagerCatchPhrase = try? rootContainer.decode(String.self, forKey: .catchPhrase) {
            catchPhrase = villagerCatchPhrase
        }
        
        // MARK: - Name
        
        // Decode english name
        name = try nameContainer?.decode(String.self, forKey: .nameEN)
    }

}
