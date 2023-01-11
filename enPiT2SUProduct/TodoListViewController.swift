//
//  TodoListViewController.swift
//  enPiT2SUProduct
//
//  Created by funabashi naoyuki on 2021/11/18.
//

import UIKit
import RealmSwift

var hensyu = -1

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var todoItems: Results<Todo>!
    var today = ""
    var tmpToday = ""
    
    var sample = true
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
       
        Access()
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        if(results != nil){ //探して書き換え
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：" + "\(results!.home)"
        }else {  //新しく書き加える
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：0"
            
        }
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 16)!]
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "リスト", style: .plain, target: nil, action: nil)
        table.dataSource = self
        table.rowHeight = 60
        //self.table.backgroundColor = UIColor.init(red: 243, green: 236, blue: 216, alpha: 1)
        
        
        todoItems = realm.objects(Todo.self)
        
        sample = UserDefaults.standard.object(forKey: "sampleBool5") as? Bool ?? true
        if sample {
            let sampleTodo1 = Todo()
            let sampleTodo2 = Todo()
            let sampleTodo3 = Todo()
            let sampleTodo4 = Todo()
            let sampleTodo5 = Todo()
            let sampleTodo6 = Todo()
                    
                    sampleTodo1.title = "朝７時に起きる"
                    sampleTodo1.homecount = 5
                    sampleTodo1.hour = 7
                    sampleTodo1.minute = 0
                    sampleTodo1.sort = 0
                    sampleTodo1.sum = 700
                    sampleTodo1.color = false
                    sampleTodo2.title = "朝食を食べる"
                    sampleTodo2.homecount = 3
                    sampleTodo2.color = true
                    sampleTodo3.title = "授業が始まる前に出席"
                    sampleTodo3.homecount = 2
                    sampleTodo3.color = true
                    sampleTodo4.title = "レポートを提出する"
                    sampleTodo4.homecount = 3
                    sampleTodo5.title = "バイトに行く"
                    sampleTodo5.homecount = 3
                    sampleTodo6.title = "寝る前に歯をみがく"
                    sampleTodo6.homecount = 2
            
                    try! realm.write{
                        realm.add(sampleTodo1)
                        realm.add(sampleTodo2)
                        realm.add(sampleTodo3)
                        realm.add(sampleTodo4)
                        realm.add(sampleTodo5)
                        realm.add(sampleTodo6)
                    }
                    sample = false
                    UserDefaults.standard.set(sample, forKey: "sampleBool5")
                }

                

        table.reloadData()
        //空の枠線削除
        table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hensyu = -1
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        
        table.reloadData()
        
       
        Access()
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        if results != nil {
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：" + "\(results!.home)"
        } else {
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：0" 
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = todoItems[indexPath.row]
        
        //ボタン判定
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoTableViewCell
        let button = UIButton()
        button.addTarget(self, action: #selector(self.count(_: )), for: UIControl.Event.touchUpInside)
        cell.todocount.tag = indexPath.row
        
        tmpToday = UserDefaults.standard.string(forKey: "TodoToday") ?? today
        if today != tmpToday {
            let realm = try! Realm()
            try! realm.write{
                todoItems[indexPath.row].color = false
            }
        }
        
        if object.color {
            cell.todocount.tintColor = UIColor.red
        } else {
            cell.todocount.tintColor = UIColor.systemGreen
        }

        cell.textLabel?.text = object.title
        cell.textLabel?.font = UIFont(name: "Noteworthy-Bold", size: 21)
        cell.countLabel.text = "+\(object.homecount)"
        cell.countLabel.font = UIFont(name: "Noteworthy-Bold", size: 21)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTodo(at:indexPath.row)
            table.reloadData()
        }
        //削除機能
        
    }

    func deleteTodo(at index: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(todoItems[index])
        }
    }
    
    @IBAction func count(_ sender: Any) {
        let realm = try! Realm()
        let result = realm.objects(Todo.self)
        
        
        let Data = Nikki()
        Access()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        if(results != nil){ //探して書き換え
            try! realm.write{
                results!.todoCount += result[(sender as AnyObject).tag].homecount
                results!.home += result[(sender as AnyObject).tag].homecount
                results!.status = true
            }
        }else {  //新しく書き加える
            Data.textNikki = ""
            Data.date = today
            Data.todoCount = result[(sender as AnyObject).tag].homecount
            Data.home = result[(sender as AnyObject).tag].homecount
            Data.status = true
            Data.targetScore = 10
            try! realm.write{
                realm.add(Data)
            }
        }
        try! realm.write{
            result[(sender as AnyObject).tag].color = true
        }
        tmpToday = today
        UserDefaults.standard.set(tmpToday, forKey: "TodoToday")
        table.reloadData()
        
        if(results != nil){
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：" + "\(results!.home)"
        }
        else{
            self.navigationController?.navigationBar.topItem?.title = "今日のえらい：" + "\(result[(sender as AnyObject).tag].homecount)"
        }
    }
    
    @objc func Access(){
        let date = Date()
        let formatterDay = DateFormatter()
        
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettei" {
            if let indexPath = table.indexPathForSelectedRow {
                guard segue.destination is TodoSetteiViewController else {
                    fatalError("Failed")
                }
                
                hensyu = indexPath.row
            }
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

}

