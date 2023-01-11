//
//  TodoSetteiViewController.swift
//  enPiT2SUProduct
//
//  Created by funabashi naoyuki on 2021/11/18.
// 不具合めも
// 編集なし保存を押すとpickerが00PMに

import UIKit
import RealmSwift
import UserNotifications

class TodoSetteiViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textBox: UITextField!
   
    @IBOutlet weak var homePickerView: UIPickerView!
    @IBOutlet weak var tuutiSwitch: UISwitch!
    @IBOutlet weak var myPickerView: UIPickerView!
    
    var request:UNNotificationRequest!
    
    let hour = ["0時","1時","2時","3時","4時","5時","6時","7時","8時","9時","10時","11時","12時","13時","14時","15時","16時","17時","18時","19時","20時","21時","22時","23時"]
    let minute = ["0分","1分","2分","3分","4分","5分","6分","7分","8分","9分","10分","11分","12分","13分","14分","15分","16分","17分","18分","19分","20分","21分","22分","23分","24分","25分","26分","27分","28分","29分","30分","31分","32分","33分","34分","35分","36分","37分","38分","39分","40分","41分","42分","43分","44分","45分","46分","47分","48分","49分","50分","51分","52分","53分","54分","55分","56分","57分","58分","59分"]
    //let ampm = ["AM","PM"]
    let home = ["1","2","3","4","5","6","7","8","9","10"]
    var item1 = 0
    var item2 = 0
    var item3 = 0
    var itemHome = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        textBox.delegate = self
        
        
        textBox.placeholder = "内容を入力してください。"
        
        
        // Do any additional setup after loading the view.
        
        tuutiSwitch.setOn(false, animated: true)
        
        myPickerView.delegate = self
        myPickerView.dataSource = self
        homePickerView.delegate = self
        homePickerView.dataSource = self
        print("\(hensyu)")
        if hensyu != -1 {
            textBox.text = todoItems[hensyu].title
            //textNumber.text = String(todoItems[hensyu].homecount)
            homePickerView.selectRow(todoItems[hensyu].homecount - 1, inComponent: 0, animated: false)
            if todoItems[hensyu].sort == 0 {
                tuutiSwitch.setOn(true, animated: true)
            }
            
            myPickerView.selectRow(todoItems[hensyu].minute, inComponent: 1, animated: false)
            myPickerView.selectRow(todoItems[hensyu].hour, inComponent: 0, animated: false)
                
            }
        }
    
    
    @IBAction func addbtn(_ sender: Any) {
        
    
        let realm = try! Realm()
        let todo = Todo()
        todo.title = textBox.text!
        
        //ほめ数を代入（数字を入力しないとエラーが起きます）
        /*
        if textNumber.text == "" {
            todo.homecount = 1
        } else {
            todo.homecount = Int(textNumber.text!)!
         } */
        todo.homecount = itemHome
        if tuutiSwitch.isOn {
            
            todo.hour = item1
            
            todo.minute = item2
            todo.sum = todo.hour * 100 + todo.minute
            todo.sort = 0
        }
        try! realm.write {
            if hensyu == -1 {
                realm.add(todo)
            }
            else {
                todoItems[hensyu].title = textBox.text!
                todoItems[hensyu].homecount = itemHome
                //todoItems[hensyu].homecount = Int(textNumber.text!)!
                if tuutiSwitch.isOn {
                    todoItems[hensyu].hour = item1
                    todoItems[hensyu].minute = item2
                    todoItems[hensyu].sum = todo.hour * 100 + todo.minute
                    todoItems[hensyu].sort = 0
                }
            }
        }
        
        
        if todo.sort == 0 {
            let date = Date()
            let cal = Calendar.current
            let comp = cal.dateComponents( [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: date)
            let todaySum = comp.hour! * 100 + comp.minute!
            
            var min = 2400
            var minid = -1
            var tmp = 2400
        
            if todoItems.count != 0 {
                for i in 0...todoItems.count - 1 {
                    if todoItems[i].sort == 0 {
                        tmp = todoItems[i].sum - todaySum
                        if tmp < 0 {
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
            }
            let triggerDate = DateComponents(hour:todoItems[minid].hour, minute:todoItems[minid].minute)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                // 通知コンテンツの作成
            let content = UNMutableNotificationContent()
            content.title = todoItems[minid].title
            content.body = "「" + todoItems[minid].title + "」" + "ができたらエラい！"
            content.sound = UNNotificationSound.default
         
                // 通知リクエストの作成
            request = UNNotificationRequest.init( identifier: "CalendarNotification", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textBox.resignFirstResponder()
        return true
    }
    
    //コンポーネントの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 1
        } else {
            return 2
        }
    }
    //各コンポーネントの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return home.count
            default:
                return 0
            }
        } else {
            switch component {
            case 0:
                return hour.count
            case 1:
                return minute.count
                /*
            case 2:
                return ampm.count
        */
            default:
                return 0
            }
            
        }
    }
    //各コンポーネントの横幅
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 1 {
            
        
        switch component {
        case 0:
            return 100
        case 1:
            return 100
            /*
        case 2:
            return 50
 */
        default:
            return 0
        }
        } else {
            return 100
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let pickerLabel = UILabel()
            pickerLabel.textAlignment = NSTextAlignment.center
            pickerLabel.font = UIFont(name: "Noteworthy-Bold", size: 20)
            
        if pickerView.tag == 0 {
            switch component {
            case 0:
                pickerLabel.text = home[row]
            default:
                break
            }
            return pickerLabel
        } else {
            switch component {
            // 1列目のテキスト
            case 0:
                pickerLabel.text = hour[row]
            // 2列目のテキスト
            case 1:
                pickerLabel.text = minute[row]
                /*
            case 2:
                pickerLabel.text = ampm[row]
 */
            default:
                break
            }
            return pickerLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            switch component {
            // 1列目が選択された時
            case 0:
                item1 = row
            // 2列目が選択された時
            case 1:
                item2 = row
                /*
            case 2:
                item3 = row
 */
            default:
                break
            }
        } else {
            switch component {
            case 0:
                itemHome = row + 1
            default:
                break
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
        
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
