//
//  Category.swift
//  Todoey
//
//  Created by Austin McMeekin on 16/10/2018.
//  Copyright © 2018 Austin McMeekin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
