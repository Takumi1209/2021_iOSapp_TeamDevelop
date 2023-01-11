//
//  Todo.swift
//  enPiT2SUProduct
//
//  Created by funabashi naoyuki on 2021/11/18.
//

import Foundation
import RealmSwift

class Todo:Object {
    @objc dynamic var title = ""
    @objc dynamic var homecount = 1
    @objc dynamic var hour = 0
    @objc dynamic var minute = 0
    @objc dynamic var sort = -1
    @objc dynamic var sum = 0
    @objc dynamic var color = false
}
