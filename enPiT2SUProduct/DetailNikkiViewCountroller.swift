//
//  DetailNikkiViewCountroller.swift
//  enPiT2SUProduct
//
//  Created by ysako on 2021/12/08.
//

import UIKit
import RealmSwift

class DetailNikkiViewCountroller: UIViewController {

    var date:String = ""
    @IBOutlet weak var textNikki: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        date = date.replacingOccurrences(of: "月", with: "")
        // Do any additional setup after loading the view.
        print(getTextNikki(str1: date))
        self.textNikki.text = getTextNikki(str1: date)
    }
    //月を取得
    func getMonth(date:String)->String{
        let month:String = String(date.dropFirst(4).dropLast(2))
        return month
    }
    func getTextNikki (str1: String) -> String{
        var str:String = ""
        var max:Int = 0
        var temp:Int
        //realmの追加
        let realm = try!Realm()
        //realmの参照
        let nikki = realm.objects(Nikki.self).filter("date LIKE '????\(str1)??'")
        for nikki in nikki{
            print(nikki.date)
            print(nikki.textNikki)
            temp = nikki.home
            if max < temp && nikki.textNikki != ""{
                max = temp
                print("tee")
            }else if max <= temp{
                print("aaa")
                max = temp
                str = nikki.textNikki
            }
            //本来はコメントアウト
            str = nikki.textNikki
        }
        return str
    }
}
