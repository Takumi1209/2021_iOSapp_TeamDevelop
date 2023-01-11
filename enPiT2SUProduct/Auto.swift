//
//  Auto.swift
//  enPiT2SUProduct
//
//  Created by 田島雄太 on 2021/12/21.
//



import Foundation
import RealmSwift
var today = ""

let calender = Calendar.current
let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
let now = calender.component(.day, from: now_day)

 


class AutoEraiCount:Object{
    @objc dynamic var eraisuu = 0
    @objc dynamic var id = ""
    
    
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(eraisuu: Int,id:String){
        let realm  = try!Realm()
        let erasiuudata = AutoEraiCount()
        
        erasiuudata.eraisuu = eraisuu
        erasiuudata.id = id
        
        try!realm.write{
            realm.add(erasiuudata,update: .modified)
        }
        
    }
    
}

class Hosuupicker: Object {
    @objc dynamic var hosuupicker = ""
    
    @objc dynamic var id = ""
    
    
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(hosuupicker: String,id: String ) {
        let realm = try! Realm()
        let hosuupickerdata = Hosuupicker()
    
       
        hosuupickerdata.hosuupicker = hosuupicker
        hosuupickerdata.id = id
        
        try! realm.write {
            realm.add(hosuupickerdata, update: .modified)
        }
    }
    
}

class Switch1: Object{
    @objc dynamic var switch1 = Bool()
    
    @objc dynamic var id = ""
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(switch1: Bool,id: String){
        let realm = try! Realm()
        let switch1data = Switch1()
        switch1data.switch1 = switch1
        switch1data.id = id
        
        try! realm.write {
            realm.add(switch1data, update: .modified)
        }
    }
}

class Switch2: Object{
    @objc dynamic var switch2 = Bool()
    
    @objc dynamic var id = ""
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(switch2: Bool,id: String){
        let realm = try! Realm()
        let switch2data = Switch2()
        switch2data.switch2 = switch2
        switch2data.id = id
        
        try! realm.write {
            realm.add(switch2data, update: .modified)
        }
    }
}

class Switch3: Object{
    @objc dynamic var switch3 = Bool()
    
    @objc dynamic var id = ""
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(switch3: Bool,id: String){
        let realm = try! Realm()
        let switch3data = Switch3()
        switch3data.switch3 = switch3
        switch3data.id = id
        
        try! realm.write {
            realm.add(switch3data, update: .modified)
        }
    }
}

class Place: Object{
    @objc dynamic var place = ""
    
    @objc dynamic var id = ""
    
    override static func primaryKey() -> String? {
           return "id"
       }
    
    static func update(place: String,id: String){
        let realm = try! Realm()
        let placedata = Place()
        placedata.place = place
        placedata.id = id
        try! realm.write {
            realm.add(placedata, update: .modified)
        }
    }
}



