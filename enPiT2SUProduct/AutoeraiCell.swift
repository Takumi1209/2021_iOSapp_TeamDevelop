//
//  TableViewCell.swift
//  zidou4
//
//  Created by 田島雄太 on 2021/12/13.
//

import UIKit
import CoreMotion
import UserNotifications
import RealmSwift



class AutoeraiCell: UITableViewCell{
   
   
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var eraisuu: UILabel!
    @IBOutlet weak var Switch: UISwitch!
    let realm = try! Realm()
    
    
    //歩数計
    let pedometer = CMPedometer()
    var results = "n/a"
    
    func hosuukei10(){
       
               
        if(CMPedometer.isStepCountingAvailable()){
                    self.pedometer.startUpdates(from: NSDate() as Date) {
                        (data: CMPedometerData?, error) -> Void in
                               
                        DispatchQueue.main.async(execute: { () -> Void in
                            if(error == nil){
                                // 歩数 NSNumber?
                                let steps = data!.numberOfSteps
                                if steps.intValue >= 10 &&  steps.intValue <= 20{
                                    self.makeNotification1()
                                }
                                
                               
                            }
                        })
                    }
                }
}
    
    func hosuukei20(){
       
               
        if(CMPedometer.isStepCountingAvailable()){
                    self.pedometer.startUpdates(from: NSDate() as Date) {
                        (data: CMPedometerData?, error) -> Void in
                               
                        DispatchQueue.main.async(execute: { () -> Void in
                            if(error == nil){
                                // 歩数 NSNumber?
                                let steps = data!.numberOfSteps
                                if steps.intValue >= 20 &&  steps.intValue <= 30{
                                    self.makeNotification2()
                                }
                                let results:String = String(format:"s: %d", steps.intValue)
                                       
                                print (results)
                            }
                        })
                    }
                }
}
    
    func timer(){
        if self.label.text == "5" {
            Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "ローカル通知"
            content.body = "10da"
            content.sound = UNNotificationSound.default
            
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            self.label.text = "10"
            User.update(name: "10", eraisuu: "5", onoff: true, id: "0")
            let userdata2 = self.realm.objects(User.self)
                
            print("5hoclear\(userdata2)")
            
        }
        }
        
        if self.label.text == "10" {
            Dispatch.DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "ローカル通知"
            content.body = "10da"
            content.sound = UNNotificationSound.default
            
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            self.label.text = "5"
            User.update(name: "5", eraisuu: "5", onoff: true, id: "0")
            let userdata2 = self.realm.objects(User.self)
                
            print("5hoclear\(userdata2)")
            
        }
        }
        
    }
    
    
    
    
        

   
    //通知機能
    //10歩
    func makeNotification1(){
            //通知タイミングを指定
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "ローカル通知"
            content.body = "10歩だる"
            content.sound = UNNotificationSound.default
            
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    
    func makeNotification2(){
            //通知タイミングを指定
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = "ローカル通知"
            content.body = "20歩だる"
            content.sound = UNNotificationSound.default
            
            //通知リクエストを作成
            let request = UNNotificationRequest(identifier: "notification002", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    
    
    
   
    
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
   
    
    //よくわからんが動いてるやつ
    @IBAction func walking(_ sender: UISwitch) {
        
            switch sender.tag {
            case 0:
                no0()
            case 1:
                no1()
                
            
                
            
            default:
               break
            }
    }

    
    //ひとつめのセルから１０個目のセルまでの動作まとめ
    func no0(){
        if Switch.isOn == true {
            timer()
           
            
        }else{
            
        }
    }
    
    
    func no1(){
        if Switch.isOn == true {
            hosuukei20()
        }else{
            
            hosuukei10()
        }
    }
    //ここまで
    
    
    
   
    
    
 //ピッカーびゅう系
    
   
    
}
