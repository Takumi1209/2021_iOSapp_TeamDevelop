//
//  target.swift
//  enPiT2SUProduct
//
//  Created by kojima shogo on 2021/12/22.
//

import UIKit
import RealmSwift

class target: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var sendItem = ""
    var decidedNum = 0
    var today = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = label[row]
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendItem = label[row]
        switch sendItem{
        case "10回":
            decidedNum = 10
        case "20回":
            decidedNum = 20
        case "30回":
            decidedNum = 30
        case "40回":
            decidedNum = 40
        case "50回":
            decidedNum = 50
        default:
            decidedNum = 10
        }
    }
    
    
    let label = ["10回","20回","30回","40回","50回"]

    @IBOutlet weak var TargetNum: UIPickerView!
    
    @IBAction func decideTarget(_ sender: UIButton) {
        let preNC = self.presentingViewController as! UITabBarController
        let preVC = preNC.selectedViewController as! GoodViewController
        
        let realm = try! Realm()
        let Data = Nikki()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        //なければ新規作成、あるなら編集
        if(results != nil){
            try! realm.write{
                results!.targetScore = decidedNum
            }
        }else {
            Data.textNikki = ""
            Data.date = today
            Data.home = 1
            Data.targetScore = 10
            Data.botanCount = 1
            Data.status = true
            Data.targetScore = decidedNum
            try! realm.write{
                realm.add(Data)
            }
        }
        
        preVC.target.text = "今日の目標：\(sendItem)"
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TargetNum.delegate = self
        TargetNum.dataSource = self
        
    }
    
    @objc func Access(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
