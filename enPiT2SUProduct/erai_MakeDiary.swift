//
//  erai_MakeDiary.swift
//  enPiT2SUProduct
//
//  Created by kojima shogo on 2021/11/25.
//

import UIKit
import RealmSwift

class erai_MakeDiary: UIViewController, UITextViewDelegate {
    
    
   
    var today = ""
    
    @IBOutlet weak var EraiContent: UITextView!
    @IBAction func Registration(_ sender: UIButton) {
        
        let realm = try! Realm()
        let Data = Nikki()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        if(results != nil){
            try! realm.write{
                results!.textNikki = EraiContent.text!
            }
        }else {
            Data.textNikki = EraiContent.text!
            Data.date = today
            Data.home = 0
            Data.targetScore = 10
            try! realm.write{
                realm.add(Data)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        EraiContent.delegate = self
        EraiContent.layer.borderColor = UIColor.black.cgColor
        EraiContent.layer.borderWidth = 1.0
        EraiContent.layer.cornerRadius = 10.0
        EraiContent.layer.masksToBounds = true
        
        self.setumei.isEditable = false
        self.setumei.isSelectable = false
        
        self.setumei.text = "今日、自分ができた行動などに対して褒めるフレーズを書いてみましょう。\nどんなに小さな事でも構いません。\n１つでも何かを達成できたのならそれは「えらい」ことです。\nまずは身近なことや「リスト」に登録してできたことを書いてみましょう！\n下の欄にはリストに登録した項目がランダムに表示されます。"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        //ここまで
        let realm = try! Realm()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        if(results != nil){
            try! realm.write{
                EraiContent.text = "\(results!.textNikki)"
            }
        }
        
        //ランダム表示
        var list: [String] = [] // 配列
        var selectedCard: String? // 取得する要素
        let result = realm.objects(Todo.self) // データを取得
        
        if result.count == 0 {
            selectedCard = "「リスト」に登録して使ってみよう！"
        } else {
            for i in 0..<result.count {
                list.append(result[i].title) // データを配列に格納
            }
            selectedCard = list.randomElement() // ランダムに要素を取得
        }
        self.TodoText.text = selectedCard
        
       
    }
    
    @objc func timecheck(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }
    
    @objc func Access(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var setumei: UITextView!
    
    @IBOutlet weak var TodoText: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
   
        

}

