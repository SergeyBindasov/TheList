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
    let items = List<Item>()
}
