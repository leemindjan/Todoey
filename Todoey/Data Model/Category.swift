//
//  Category.swift
//  Todoey
//
//  Created by Dan Le on 3/7/19.
//  Copyright © 2019 Dan Le. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
