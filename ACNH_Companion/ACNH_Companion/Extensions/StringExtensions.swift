//
//  StringExtensions.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/12/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation

// Adds ways to capitalise and set back to lower case for the first letter
extension String {
    // MARK: - Capitalize first letter of a string
    
    /*
     Hacking with Swift:
     https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string
     */
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    mutating func lowercaseFirstLetter() {
        self = self.lowercasingFirstLetter()
    }
}
