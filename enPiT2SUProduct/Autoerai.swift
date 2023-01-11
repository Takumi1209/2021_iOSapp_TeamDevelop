//
//  ViewController.swift
//  zidou4
//
//  Created by 田島雄太 on 2021/12/13.
//

import CoreMotion
import UIKit
import RealmSwift
import UserNotifications
import CoreLocation


 




class Autoerai: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {
    let UD = UserDefaults.standard
   
    let realm = try! Realm()
    
    let pedometer = CMPedometer()
    @IBOutlet weak var hosuu_ue: UILabel!
    @IBOutlet weak var hosuugennzai: UILabel!
    @IBOutlet weak var hosuulabel: UILabel!
    @IBOutlet weak var hosuupicker: UIPickerView!
    @IBOutlet weak var hosuuswitch: UISwitch!
    @IBOutlet weak var hosuusita: UILabel!
    @IBOutlet weak var hosuueraibutton: UIButton!
    @IBOutlet weak var hosuueraisuulabel: UILabel!
    
    var today = ""
    
    @IBOutlet weak var logue: UILabel!
    @IBOutlet weak var loglabel1: UILabel!
    @IBOutlet weak var loglabel2: UILabel!
    @IBOutlet weak var logswitch: UISwitch!
    @IBOutlet weak var logsita: UILabel!
    @IBOutlet weak var logeraibutton: UIButton!
    @IBOutlet weak var logeraisuubutton: UILabel!
    @IBOutlet weak var hosuumigi: UILabel!
    
    
    let locationManager = CLLocationManager()
    var moniteringRegion: CLCircularRegion = CLCircularRegion()
    
    @IBOutlet weak var iedeue: UILabel!
    @IBOutlet weak var iedelabel1: UILabel!
    @IBOutlet weak var iedelabel2: UILabel!
    @IBOutlet weak var iedeswitch: UISwitch!
    @IBOutlet weak var iedebotoon: UIButton!
    @IBOutlet weak var iedesita: UILabel!
    @IBOutlet weak var iedeeraisuulbutton: UIButton!
    @IBOutlet weak var iedeeraisuulabel: UILabel!
    
   
    
    let hosuudatalist = ["2000歩","5000歩","10000歩","15000歩","20000歩"]
    
   
  
   
    ///////////////////////////////////////////
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        Access()
       
        let realm = try! Realm()
       
        
        let pickerdata2 = realm.objects(Hosuupicker.self)
        let pickerdatafirst = pickerdata2.first
        if (pickerdatafirst != nil)
            {
            hosuulabel.text = "\(pickerdatafirst!.hosuupicker)"
            if hosuulabel.text == "2000歩" {
                hosuueraisuulabel.text = "+1"
            }else if hosuulabel.text == "5000歩"{
                hosuueraisuulabel.text = "+2"
            }else if hosuulabel.text == "10000歩"{
                hosuueraisuulabel.text = "+3"
            }else if hosuulabel.text == "15000歩"{
                hosuueraisuulabel.text = "+4"
            }else{
                hosuueraisuulabel.text = "+5"
            }
        }else {
            hosuulabel.text = "歩数を設定してね"
        }
        
        
        
        let switch1data = realm.objects(Switch1.self)
        let switch1datafirst = switch1data.first
        if(switch1datafirst != nil)
        {
            hosuuswitch.isOn = switch1data[0].switch1
        } else{
            hosuuswitch.isOn = false
        }
        let switch2data = realm.objects(Switch2.self)
        let switch2datafirst = switch2data.first
        if(switch2datafirst != nil)
        {
            logswitch.isOn = switch2data[0].switch2
        } else{
            logswitch.isOn = false
        }
        let switch3data = realm.objects(Switch3.self)
        let switch3datafirst = switch3data.first
        if(switch3datafirst != nil)
        {
            iedeswitch.isOn = switch3data[0].switch3
        } else{
            iedeswitch.isOn = false
        }
        
        
        let  placedata = self.realm.objects(Place.self)
        let placefirst = placedata.first
        if(placefirst != nil)
        {
            iedelabel1.text = "今日も外出しよう"
            iedelabel2.text = "自宅：\(placedata[0].place)"
        }else{
            iedelabel1.text = "地点を登録してください"
            iedelabel2.text = "横のボタンで登録できます　→"
        }
       
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hosuupicker.delegate = self
        hosuupicker.dataSource = self
        
       
        
        let calendar = Calendar(identifier: .gregorian)
        let dc = calendar.dateComponents(in: .current, from: Date())
        let startOfDate = DateComponents(calendar: calendar, timeZone: .current, year: dc.year, month: dc.month, day: dc.day).date!
        let endOfDate = calendar.date(byAdding: DateComponents(day: 1), to: startOfDate)!
        
        updateStepLabel(start: startOfDate, end: endOfDate)
        
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        let firstLunchKey = "firstLunchKey"
        if userDefaults.bool(forKey: firstLunchKey) {
           
            
           
           
           
            
            
            let pickerdata2 = realm.objects(Hosuupicker.self)
            let pickerdatafirst = pickerdata2.first
            if (pickerdatafirst != nil)
                {
                hosuulabel.text = "\(pickerdatafirst!.hosuupicker)"
               
            }else {
                hosuulabel.text = "歩数を設定してね"
                hosuueraisuulabel.text = "+1"
            }
                
            let switch1data = realm.objects(Switch1.self)
            let switch1datafirst = switch1data.first
            if(switch1datafirst != nil)
            {
                hosuuswitch.isOn = switch1data[0].switch1
            } else{
                hosuuswitch.isOn = false
            }
            
            let  placedata = self.realm.objects(Place.self)
            let placefirst = placedata.first
            if(placefirst != nil)
            {
                iedelabel1.text = "スイッチをオンにしてみよう！！"
                iedelabel2.text = "現在地\(placedata[0].place)"
            }else{
                iedelabel1.text = "地点を登録してください"
                iedelabel2.text = "横のボタンで登録できます　→"
            }
            
            
            
    }
        
        
        
      
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
       
        
   
        //realm.deleteAll() 全消し
        //realm.add()  追加
        //ここにデータ書き込み
       try! realm.write {
       
            
           
                        }
        
      
    }
    
    
    
    
   
    func getCountStepByPedometer(from start: Date, to end: Date, completion handler: @escaping CMPedometerHandler) {
        pedometer.queryPedometerData(from: start, to: end, withHandler: handler)
    }
    
    func updateStepLabel(start: Date, end: Date) {
        getCountStepByPedometer(from: start, to: end) { (data, error) in
            DispatchQueue.main.async { [self] in
                if let value = data {
                    self.hosuugennzai.text = "現在\(value.numberOfSteps)歩です！"
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
                                       
                                       results!.home += 5
                                    results!.status = true
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
    

    

func numberOfComponents(in hosuupicker: UIPickerView) -> Int {
            return 1
        }
        
// UIPickerViewの行数、リストの数
func pickerView(_ hosuupicker: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
            hosuudatalist.count
        }
        
// UIPickerViewの最初の表示
func pickerView(_ hosuupicker: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
            return hosuudatalist[row]
        }
        
// UIPickerViewのRowが選択された時の挙動
func pickerView(_ hosuupicker: UIPickerView,didSelectRow row: Int,inComponent component: Int) {
            
            Hosuupicker.update(hosuupicker: hosuudatalist[row], id: "0")
            let pickerdata2 = realm.objects(Hosuupicker.self)
            print("全てのデータ\(pickerdata2)")
            hosuulabel.text = "\(pickerdata2[0].hosuupicker)"
    if pickerdata2[0].hosuupicker == "2000歩" {
        hosuueraisuulabel.text = "+1"
    }else if pickerdata2[0].hosuupicker == "5000歩"{
        hosuueraisuulabel.text = "+2"
    }else if pickerdata2[0].hosuupicker == "10000歩"{
        hosuueraisuulabel.text = "+3"
    }else if pickerdata2[0].hosuupicker == "15000歩"{
        hosuueraisuulabel.text = "+4"
    }else {
        hosuueraisuulabel.text = "+5"
    }
           
        }
   
 //スイッチ系まとめ
@IBAction func hosuuswitch(_ sender: UISwitch) {
        if sender.isOn == true{
            Switch1.update(switch1: true,id: "0")
            let switch1data = realm.objects(Switch1.self)
            hosuuswitch.isOn = switch1data[0].switch1
            
            print(switch1data)
            
            
            
        }else{
            Switch1.update(switch1: false,id: "0")
            let switch1data = realm.objects(Switch1.self)
            hosuuswitch.isOn = switch1data[0].switch1
            print(switch1data)
        }
    }
    
@IBAction func logswitch(_ sender: UISwitch) {
            if sender.isOn == true{
                Switch2.update(switch2: true,id: "0")
                let switch2data = realm.objects(Switch2.self)
                logswitch.isOn = switch2data[0].switch2
                print(switch2data)
                //現在のカレンダ情報を設定
                    let calender = Calendar.current
                    //日本時間を設定
                    let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                    //日付判定結果
                    var judge = Bool()

                    // 日時経過チェック
                    if UD.object(forKey: "today") != nil {
                         let past_day = UD.object(forKey: "today") as! Date
                         let now = calender.component(.day, from: now_day)
                         let past = calender.component(.day, from: past_day)

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
                        let dialog = UIAlertController(title: "アプリ起動：＋１えらい", message: "毎日アプリを開くごとにえらいが貯まるよ", preferredStyle: .alert)

                            //ボタンのタイトル
                            
                        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            //実際に表示させる
                        self.present(dialog, animated: true, completion: nil)

                         /* 今の日時を保存 */
                         UD.set(now_day, forKey: "today")
                     }

                     /* 日付が変わった場合はtrueの処理 */
                     if judge == true {
                          judge = false
                        UD.set(now_day, forKey: "today")
                        //日付が変わった時の処理をここに書く
                     }
                     else {
                      //日付が変わっていない時の処理をここに書く
                     }
                
                
            }else{
                Switch2.update(switch2: false,id: "0")
                let switch2data = realm.objects(Switch2.self)
                logswitch.isOn = switch2data[0].switch2
                print(switch2data)
            }
        }

// ログイン関連
   
    //日付変更検知関数
    
 // 家出関連
    //新しいロケーションデータが取得された時に実行されます
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let loc = locations.last else { return }
            
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                
                if let error = error {
                    print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?[0] {
                    
                    var locInfo = ""
                   
                    locInfo = locInfo + "\(placemark.administrativeArea ?? "")"
                    locInfo = locInfo + "\(placemark.locality ?? "")\n"
                    
                    locInfo = locInfo + " \(placemark.name ?? "")"
                    Place.update(place: locInfo, id: "0")
                    
                    self.iedelabel2.text = locInfo
                    let moniteringCordinate = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
                    self.moniteringRegion = CLCircularRegion.init(center: moniteringCordinate, radius: 100.0, identifier: "zitaku")
                    self.locationManager.startMonitoring(for: self.moniteringRegion)
                }
            })
    }
    //ロケーションデータが取得できなかった時に実行されます。
    
    
    @IBAction func iedeswitch(_ sender: UISwitch) {
                    if sender.isOn == true{
                        Switch3.update(switch3: true,id: "0")
                        let switch3data = realm.objects(Switch3.self)
                        iedeswitch.isOn = switch3data[0].switch3
                        print(switch3data)
                        
                       
                    }else{
                        Switch3.update(switch3: false,id: "0")
                        let switch3data = realm.objects(Switch3.self)
                        iedeswitch.isOn = switch3data[0].switch3
                        
                        print(switch3data)
                    }
                }
    
    
  
    // 位置情報取得認可
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    switch status {
    case .authorizedAlways:
       
    break
    case .authorizedWhenInUse:
                manager.requestAlwaysAuthorization()
    break
    case .notDetermined:
    break
    case .restricted:
    break
    case .denied:
    break
    default:
    break
            }
        }
 
    // モニタリング開始成功時に呼ばれる
       func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
           print("モニタリング開始")
       }

       // モニタリングに失敗時に呼ばれる
       func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
           print("モニタリング失敗")
       }

       // ジオフェンス領域侵入時に呼ばれる
       func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
           print("ジオフェンス侵入")
       
       }

       // ジオフェンス領域離脱時に呼ばれる
       func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let switch3data = realm.objects(Switch3.self)
        let switch3datafirst = switch3data.first
        if(switch3datafirst != nil)
        {
            iedeswitch.isOn = switch3data[0].switch3
            if switch3data[0].switch3 == true   {
                //現在のカレンダ情報を設定
                let calender = Calendar.current
                //日本時間を設定
                let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
                
                print(now_day)
                
               
               
                //日付判定結果
                var judge = Bool()
                
                

                // 日時経過チェック
                if UD.object(forKey: "iede") != nil {
                     let past_day = UD.object(forKey: "iede") as! Date
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
                   let Data = Nikki()
                    Access()
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
                   basyoNotification()
               
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
                   basyoNotification()
                   UD.set(now_day, forKey: "iede")
                  
                }
                else {
                 print("iiiiiii")
                   
                   
                 //日付が変わっていない時の処理をここに書く
                }
            } else {
                print("akakakakak")
            }

        } else{
            iedeswitch.isOn = false
        }
        
      
        
       }

       // ジオフェンスの情報が取得できないときに呼ばれる
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("モニタリングエラー")
       }

      
    @objc func Access(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }
    
   func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
            if state == .inside {
                print("登録した領域の内側にいます")
                
                
            } else if state == .outside {
                print("登録した領域の外側にいます")
                
                
            } else {
                print("わかりません")
            }
        }
        
        
    
   
    

   
    @IBAction func tourokubutton(_ sender: Any) {
        
        
        //アラート生成
        //UIAlertControllerのスタイルがalert
        let alert: UIAlertController = UIAlertController(title: "現在地を自宅として登録しますか？", message:  "何度でも登録できます", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.locationManager.requestLocation()
            self.iedelabel1.text = "外に出てみよう！！"
            
          
            
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            self.iedelabel2.text = "自宅を登録してね！！"
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    
    
   
    func basyoNotification(){
            //通知タイミングを指定
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
            
            //通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "外出してえらい！！"
        content.body = "＋３えらい"

            content.sound = UNNotificationSound.default
        
        
            
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: "場所", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    
  
}


