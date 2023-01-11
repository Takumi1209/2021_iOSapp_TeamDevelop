//
//  GoodViewController.swift
//  enPiT2SUProduct
//
//  Created by kojima shogo on 2021/11/14.
//

import CoreMotion
import UIKit
import RealmSwift
import UserNotifications
import CoreLocation


class GoodViewController: UIViewController {
    let pedometer = CMPedometer()
    let UD = UserDefaults.standard
    var eraiCount = 0
    var targetNum = ""
    var today = ""
    let realm = try! Realm()

    @IBOutlet weak var eraiButton: UIImageView!
    @IBOutlet weak var eraiCountLabel: UILabel!
    @IBOutlet weak var target: UILabel!
    @IBOutlet weak var time: UILabel!
    var myTimer: Timer!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        target.text = "今日の目標：10回"
        eraiButton.isUserInteractionEnabled = true
        eraiButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GoodViewController.imageViewTapped(_sender:))))
        timecheck()
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timecheck), userInfo: nil, repeats: true)
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(
                self,
                selector: #selector(self.judgeDate2),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        
        let calendar = Calendar(identifier: .gregorian)
        let dc = calendar.dateComponents(in: .current, from: Date())
        let startOfDate = DateComponents(calendar: calendar, timeZone: .current, year: dc.year, month: dc.month, day: dc.day).date!
        let endOfDate = calendar.date(byAdding: DateComponents(day: 1), to: startOfDate)!
        updateStepLabel(start: startOfDate, end: endOfDate)
        
    }
    
    @IBAction func segue(_ sender: UIButton) {
        let SecondController = storyboard?.instantiateViewController(withIdentifier: "second") as! target
    
        present(SecondController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
       
       
        super.viewDidAppear(animated)
        
       

        
       
        let realm = try! Realm()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        if(results != nil){
            if(Int(results!.home) >= results!.targetScore ){
                target.text = "目標達成！！"
                eraiCountLabel.text = "\(results!.home)"
            }
            else{
                eraiCountLabel.text = "\(results!.home)"
            }
        }
        else{
            eraiCountLabel.text = "0"
            target.text = "今日の目標：10回"
        }
        
    }
    
    @objc func timecheck(){
        let date = Date()
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yddMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        time.text = (formatterDay.string(from: date))

    }
    
    @objc func Access(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }
    
    @objc func imageViewTapped(_sender: UITapGestureRecognizer){
        let realm = try! Realm()
        let Data = Nikki()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        //なければ新規作成、あるなら編集
        if(results != nil){
            try! realm.write{
                results!.home += 1
                results!.botanCount += 1
                results!.status = true
                if(Int(results!.home) >= results!.targetScore ){
                    target.text = "目標達成！！"
                    eraiCountLabel.text = "\(results!.home)"
                }
                else{
                    eraiCountLabel.text = "\(results!.home)"
                }
                
            }
        }else {
            Data.textNikki = ""
            Data.date = today
            Data.home = 1
            Data.botanCount = 1
            Data.targetScore = 10
            Data.status = true
            try! realm.write{
                realm.add(Data)
            }
            eraiCountLabel.text = "\(Data.home)"
        }
        
        
    }
        


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func judgeDate2(){
        let switch2data = realm.objects(Switch2.self)
        let switch2datafirst = switch2data.first
        if(switch2datafirst != nil)
        {
            
            if switch2data[0].switch2 == true   {
                //現在のカレンダ情報を設定
                let calender = Calendar.current
                //日本時間を設定
                let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                
                print(now_day)
                
               
               
                //日付判定結果
                var judge = Bool()
                
                

                // 日時経過チェック
                if UD.object(forKey: "today") != nil {
                     let past_day = UD.object(forKey: "today") as! Date
                     let now = calender.component(.day, from: now_day)
                     let past = calender.component(.day, from: past_day)

                    
                    print("\(now)でっっっっっっっっs")
                    print(past)
                     //日にちが変わっていた場合
                     if now != past {
                        judge = true
                       
                     }
                     else {
                        judge = false
                        
                     }
                 }
                //初回実行のみelse
                else {
                    judge = true
                    /* 今の日時を保存 */
                    UD.set(now_day, forKey: "iede")
                   
                    let dialog = UIAlertController(title: "ログイン達成", message: "", preferredStyle: .alert)
                        //ボタンのタイトル
                        
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        //実際に表示させる
                    self.present(dialog, animated: true, completion: nil)

               
                }


                /* 日付が変わった場合はtrueの処理 */
                if judge == true {
                   judge = false//日付が変わった時の処理をここに書く
                   //ログイン関連
                   let Data = Nikki()
                   let Alldata = realm.objects(Nikki.self)
                   let predicate = NSPredicate(format: "date == %@", today)
                   
                   let results = Alldata.filter(predicate).first
                   print(Alldata)
                   if(results != nil){ //探して書き換え
                       try! realm.write{
                           
                           results!.home += 1
                        results!.status = true
                       }
                   }else {  //新しく書き加える
                       Data.textNikki = ""
                       Data.date = today
                    Data.status = true
                       Data.home = 1
                       Data.targetScore = 10
                       try! realm.write{
                           realm.add(Data)
                       }
                   }
                    let dialog = UIAlertController(title: "ログイン達成", message: "", preferredStyle: .alert)
                        //ボタンのタイトル
                        
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        //実際に表示させる
                    self.present(dialog, animated: true, completion: nil)

                   
                   UD.set(now_day, forKey: "today")
                  
                }
                else {
                 print("iiiiiii")
                   
                   
                 //日付が変わっていない時の処理をここに書く
                }
            } else {
                print("akakakakak")
            }

        } else{
            print("nani")
        }
        
      
        
    }
    
    
    func getCountStepByPedometer(from start: Date, to end: Date, completion handler: @escaping CMPedometerHandler) {
        pedometer.queryPedometerData(from: start, to: end, withHandler: handler)
    }
    
    func updateStepLabel(start: Date, end: Date) {
        getCountStepByPedometer(from: start, to: end) { (data, error) in
            DispatchQueue.main.async { [self] in
                if let value = data {
                    
                    let pickerdata2 = realm.objects(Hosuupicker.self)
                    if  Int(truncating: value.numberOfSteps) >= 2000 && pickerdata2[0].hosuupicker == "2000歩"{
                        let switch1data = realm.objects(Switch1.self)
                        let switch1datafirst = switch1data.first
                        if(switch1datafirst != nil)
                        {
                            
                            if switch1data[0].switch1 == true   {
                                
                                //現在のカレンダ情報を設定
                                let calender = Calendar.current
                                //日本時間を設定
                                let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                                //日付判定結果
                                var judge = Bool()

                                // 日時経過チェック
                                if UD.object(forKey: "hosuu") != nil {
                                     let past_day = UD.object(forKey: "hosuu") as! Date
                                     let now = calender.component(.day, from: now_day)
                                     let past = calender.component(.day, from: past_day)

                                     //日にちが変わっていた場合
                                     if now != past {
                                        judge = true
                                     }
                                     else {
                                        judge = false
                                     }
                                }else {
                                    judge = true
                                   
                                   
                                    /* 今の日時を保存 */
                                    UD.set(now_day, forKey: "hosuu")
                                }
                                if judge == true {
                                     judge = false
                                   
                                   let dialog = UIAlertController(title: "2000歩歩きました", message: "", preferredStyle: .alert)
                                       //ボタンのタイトル
                                       
                                    dialog.addAction(UIAlertAction(title: "＋１えらい！", style: .default, handler: nil))

                                       //実際に表示させる
                                   self.present(dialog, animated: true, completion: nil)
                                   let Data = Nikki()
                                   let Alldata = realm.objects(Nikki.self)
                                   let predicate = NSPredicate(format: "date == %@", today)
                                   
                                   let results = Alldata.filter(predicate).first
                                   print(Alldata)
                                   if(results != nil){ //探して書き換え
                                       try! realm.write{
                                           
                                           results!.home += 1
                                        results!.status = true
                                       }
                                   }else {  //新しく書き加える
                                       Data.textNikki = ""
                                       Data.date = today
                                    Data.status = true
                                    Data.targetScore = 10

                                       
                                       Data.home = 1
                                       try! realm.write{
                                           realm.add(Data)
                                       }
                                    
                                   }
                                    UD.set(now_day, forKey: "hosuu")
                       
                                }else {
                                    print("FFFF")
                                    }
                             
                                
                            }else{
                                print("PPPPP")
                            }
                            
                        }
                    }else if Int(truncating: value.numberOfSteps) >= 5000 && pickerdata2[0].hosuupicker == "5000歩"{
                        let switch1data = realm.objects(Switch1.self)
                        let switch1datafirst = switch1data.first
                        if(switch1datafirst != nil)
                        {
                            
                            if switch1data[0].switch1 == true   {
                                
                                //現在のカレンダ情報を設定
                                let calender = Calendar.current
                                //日本時間を設定
                                let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                                //日付判定結果
                                var judge = Bool()

                                // 日時経過チェック
                                if UD.object(forKey: "hosuu") != nil {
                                     let past_day = UD.object(forKey: "hosuu") as! Date
                                     let now = calender.component(.day, from: now_day)
                                     let past = calender.component(.day, from: past_day)

                                     //日にちが変わっていた場合
                                     if now != past {
                                        judge = true
                                     }
                                     else {
                                        judge = false
                                     }
                                }else {
                                    judge = true
                                   
                                   
                                    /* 今の日時を保存 */
                                    UD.set(now_day, forKey: "hosuu")
                                }
                                if judge == true {
                                     judge = false
                                   
                                   let dialog = UIAlertController(title: "5000歩歩きました", message: "", preferredStyle: .alert)
                                       //ボタンのタイトル
                                       
                                    dialog.addAction(UIAlertAction(title: "＋２えらい！", style: .default, handler: nil))

                                       //実際に表示させる
                                   self.present(dialog, animated: true, completion: nil)
                                   let Data = Nikki()
                                   let Alldata = realm.objects(Nikki.self)
                                   let predicate = NSPredicate(format: "date == %@", today)
                                   
                                   let results = Alldata.filter(predicate).first
                                   print(Alldata)
                                   if(results != nil){ //探して書き換え
                                       try! realm.write{
                                           
                                           results!.home += 2
                                        results!.status = true
                                       }
                                   }else {  //新しく書き加える
                                       Data.textNikki = ""
                                       Data.date = today
                                    Data.status = true
                                    Data.targetScore = 10

                                       
                                       Data.home = 2
                                       try! realm.write{
                                           realm.add(Data)
                                       }
                                   }

                                    UD.set(now_day, forKey: "hosuu")
                                }else {
                                    print("FFFF")
                                    }
                             
                                
                            }else{
                                print("PPPPP")
                            }
                            
                        }
                        }else if Int(truncating: value.numberOfSteps) >= 10000 && pickerdata2[0].hosuupicker == "10000歩"{
                            let switch1data = realm.objects(Switch1.self)
                            let switch1datafirst = switch1data.first
                            if(switch1datafirst != nil)
                            {
                                
                                if switch1data[0].switch1 == true   {
                                    
                                    //現在のカレンダ情報を設定
                                    let calender = Calendar.current
                                    //日本時間を設定
                                    let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                                    //日付判定結果
                                    var judge = Bool()

                                    // 日時経過チェック
                                    if UD.object(forKey: "hosuu") != nil {
                                         let past_day = UD.object(forKey: "hosuu") as! Date
                                         let now = calender.component(.day, from: now_day)
                                         let past = calender.component(.day, from: past_day)

                                         //日にちが変わっていた場合
                                         if now != past {
                                            judge = true
                                         }
                                         else {
                                            judge = false
                                         }
                                    }else {
                                        judge = true
                                       
                                       
                                        /* 今の日時を保存 */
                                        UD.set(now_day, forKey: "hosuu")
                                    }
                                    if judge == true {
                                         judge = false
                                       
                                       let dialog = UIAlertController(title: "10000歩歩きました", message: "", preferredStyle: .alert)
                                           //ボタンのタイトル
                                           
                                        dialog.addAction(UIAlertAction(title: "＋３えらい！", style: .default, handler: nil))

                                           //実際に表示させる
                                       self.present(dialog, animated: true, completion: nil)
                                       let Data = Nikki()
                                       let Alldata = realm.objects(Nikki.self)
                                       let predicate = NSPredicate(format: "date == %@", today)
                                       
                                       let results = Alldata.filter(predicate).first
                                       print(Alldata)
                                       if(results != nil){ //探して書き換え
                                           try! realm.write{
                                               
                                               results!.home += 3
                                            results!.status = true
                                           }
                                       }else {  //新しく書き加える
                                           Data.textNikki = ""
                                           Data.date = today
                                        Data.status = true
                                        Data.targetScore = 10

                                           
                                           Data.home = 3
                                           try! realm.write{
                                               realm.add(Data)
                                           }
                                       }

                           
                                    }else {
                                        print("FFFF")
                                        }
                                    UD.set(now_day, forKey: "hosuu")
                                    
                                }else{
                                    print("PPPPP")
                                }
                                
                            }
                        }else if Int(truncating: value.numberOfSteps) >= 15000 && pickerdata2[0].hosuupicker == "15000歩"{
                            let switch1data = realm.objects(Switch1.self)
                            let switch1datafirst = switch1data.first
                            if(switch1datafirst != nil)
                            {
                                
                                if switch1data[0].switch1 == true   {
                                    
                                    //現在のカレンダ情報を設定
                                    let calender = Calendar.current
                                    //日本時間を設定
                                    let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                                    //日付判定結果
                                    var judge = Bool()

                                    // 日時経過チェック
                                    if UD.object(forKey: "hosuu") != nil {
                                         let past_day = UD.object(forKey: "hosuu") as! Date
                                         let now = calender.component(.day, from: now_day)
                                         let past = calender.component(.day, from: past_day)

                                         //日にちが変わっていた場合
                                         if now != past {
                                            judge = true
                                         }
                                         else {
                                            judge = false
                                         }
                                    }else {
                                        judge = true
                                       
                                       
                                        /* 今の日時を保存 */
                                        UD.set(now_day, forKey: "hosuu")
                                    }
                                    if judge == true {
                                         judge = false
                                       
                                       let dialog = UIAlertController(title: "15000歩歩きました", message: "", preferredStyle: .alert)
                                           //ボタンのタイトル
                                           
                                        dialog.addAction(UIAlertAction(title: "＋４えらい！", style: .default, handler: nil))

                                           //実際に表示させる
                                       self.present(dialog, animated: true, completion: nil)
                                       let Data = Nikki()
                                       let Alldata = realm.objects(Nikki.self)
                                       let predicate = NSPredicate(format: "date == %@", today)
                                       
                                       let results = Alldata.filter(predicate).first
                                       print(Alldata)
                                       if(results != nil){ //探して書き換え
                                           try! realm.write{
                                               
                                               results!.home += 4
                                            results!.status = true
                                           }
                                       }else {  //新しく書き加える
                                           Data.textNikki = ""
                                           Data.date = today
                                        Data.status = true
                                        Data.targetScore = 10

                                           
                                           Data.home = 4
                                           try! realm.write{
                                               realm.add(Data)
                                           }
                                       }
                                        UD.set(now_day, forKey: "hosuu")
                           
                                    }else {
                                        print("FFFF")
                                        }
                                 
                                    
                                }else{
                                    print("PPPPP")
                                }
                                
                            }
                        }else if Int(truncating: value.numberOfSteps) >= 20000 && pickerdata2[0].hosuupicker == "20000歩"{
                            
                        let switch1data = realm.objects(Switch1.self)
                    let switch1datafirst = switch1data.first
                    if(switch1datafirst != nil)
                    {
                        
                        if switch1data[0].switch1 == true   {
                            
                            //現在のカレンダ情報を設定
                            let calender = Calendar.current
                            //日本時間を設定
                            let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                            //日付判定結果
                            var judge = Bool()

                            // 日時経過チェック
                            if UD.object(forKey: "hosuu") != nil {
                                 let past_day = UD.object(forKey: "hosuu") as! Date
                                 let now = calender.component(.day, from: now_day)
                                 let past = calender.component(.day, from: past_day)

                                 //日にちが変わっていた場合
                                 if now != past {
                                    judge = true
                                 }
                                 else {
                                    judge = false
                                 }
                            }else {
                                judge = true
                               
                               
                                /* 今の日時を保存 */
                                UD.set(now_day, forKey: "hosuu")
                            }
                            if judge == true {
                                 judge = false
                               
                               let dialog = UIAlertController(title: "20000歩歩きました", message: "", preferredStyle: .alert)
                                   //ボタンのタイトル
                                   
                                dialog.addAction(UIAlertAction(title: "＋５えらい！", style: .default, handler: nil))

                                   //実際に表示させる
                               self.present(dialog, animated: true, completion: nil)
                               let Data = Nikki()
                               let Alldata = realm.objects(Nikki.self)
                               let predicate = NSPredicate(format: "date == %@", today)
                               
                               let results = Alldata.filter(predicate).first
                               print(Alldata)
                               if(results != nil){ //探して書き換え
                                   try! realm.write{
                                    results!.status = true
                                       results!.home += 5
                                   }
                               }else {  //新しく書き加える
                                   Data.textNikki = ""
                                   Data.date = today
                                Data.status = true
                                Data.targetScore = 10

                                   
                                   Data.home = 5
                                   try! realm.write{
                                       realm.add(Data)
                                   }
                               }
                                UD.set(now_day, forKey: "hosuu")
                   
                            }else {
                                print("FFFF")
                                }
                         
                            
                        }else{
                            print("PPPPP")
                        }
                        
                    }else{}
                    
                    
                    
                }
                    
            }
    }
    }
  

}
}
