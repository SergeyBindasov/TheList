//
//  Category.swift
//  TheList
//
//  Created by Sergey on 21.01.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorString: String = ""
    let items = List<Item>()
    
}
