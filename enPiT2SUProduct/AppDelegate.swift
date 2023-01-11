//
//  AppDelegate.swift
//  enPiT2SUProduct
//
//  Created by 後藤祐一 on 2021/09/24.
//

import UIKit
import os
import UserNotifications
import RealmSwift
import CoreMotion

var todoItems: Results<Todo>!

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let UD = UserDefaults.standard
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //通知
        UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]){
                    (granted, _) in
                    if granted{
                        UNUserNotificationCenter.current().delegate = self
                    }
                }

      
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func judgeDate2(){
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
            
            print("AAAAA")
             /* 今の日時を保存 */
             UD.set(now_day, forKey: "today")
           
        
         }

         /* 日付が変わった場合はtrueの処理 */
         if judge == true {
            judge = false//日付が変わった時の処理をここに書く
            //ログイン関連
            
            
           
               
            let dialog = UIAlertController(title: "ログイン達成", message: "", preferredStyle: .alert)
                //ボタンのタイトル
                
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //実際に表示させる
            self.window?.rootViewController?.present(dialog, animated: true, completion: nil)
            
            UD.set(now_day, forKey: "today")
           
          
               
            
         }
         else {
          print("iiiiiii")
            
            
          //日付が変わっていない時の処理をここに書く
         }
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 
        os_log("Notified")
        // アプリ起動時も通知を行う
        completionHandler([.sound, .alert ])
        print("1")
        let date = Date() // May 4, 2020, 11:36 AM
         
        let cal = Calendar.current
        let comp = cal.dateComponents(
            [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,
             Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
             from: date)
        let todaySum = comp.hour! * 100 + comp.minute!
        
        
        
        var min = 2400
        var minid = -1
        var tmp = 2400
        
        if todoItems.count != 0 {
            for i in 0...todoItems.count - 1 {
                if todoItems[i].sort == 0 {
                    tmp = todoItems[i].sum - todaySum
                    if tmp <= 0 {
                        tmp = 2400
                    }
                    if tmp < min {
                        min = tmp
                        minid = i
                    }
                }
            }
            if minid == -1 {
                for i in 0...todoItems.count - 1 {
                    if todoItems[i].sort == 0 {
                        if todoItems[i].sum < min {
                            min = todoItems[i].sum
                            minid = i
                        }
                    }
                }
            }
            let triggerDate = DateComponents(hour:todoItems[minid].hour, minute:todoItems[minid].minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                // 通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = todoItems[minid].title
            content.body = "「" + todoItems[minid].title + "」" + "ができたらエラい！"
            content.sound = UNNotificationSound.default
         
                // 通知リクエストの作成
            var request:UNNotificationRequest!
            request = UNNotificationRequest.init( identifier: "CalendarNotification", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
        
         
    }
}
 
