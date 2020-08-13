//
//  Category.swift
//  Todoey
//
//  Created by user172197 on 8/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var  name = ""
    let items = List<Item>()
    
}
