//
//  Resource.swift
//  ACNH_Companion
//
//  Created by user160075 on 7/3/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to credit a reference/resource
class Resource: NSObject {
    var provider: String?
    var usage: String?
    var link: String?
    
    init(provider: String, usage: String, link: String) {
        self.provider = provider
        self.usage = usage
        self.link = link
    }
}
