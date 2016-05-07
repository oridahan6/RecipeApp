//
//  ParseFile.swift
//  Recipes
//
//  Created by Ori Dahan on 07/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

import Parse

class ParseFile: NSObject {

    var parseFile: PFFile!
    
    init(parseFile: PFFile) {
        super.init()
        
        self.parseFile = parseFile
    }
    
    func getUrl() -> String {
        if let url = self.parseFile.url {
            return url
        }
        return ""
    }

}

