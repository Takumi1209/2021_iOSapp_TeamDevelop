//
//  Nikki.swift
//  enPiT2SUProduct
//
//  Created by funabashi naoyuki on 2021/11/26.
//

import Foundation
import RealmSwift

class Nikki:Object {
    @objc dynamic var textNikki = ""
    @objc dynamic var home = 0
    @objc dynamic var date = ""
    @objc dynamic var status: Bool = false
    @objc dynamic var targetScore: Int = 0
    
    @objc dynamic var botanCount = 0 //ボタンで押されたカウント数
    @objc dynamic var todoCount = 0 //todoで増えたカウント数
    @objc dynamic var autoEraiCount = 0 //オートで増えたカウント数
}
