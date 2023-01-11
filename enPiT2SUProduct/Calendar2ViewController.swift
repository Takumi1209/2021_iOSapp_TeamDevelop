//
//  Calendar2ViewController.swift
//  enPiT2SUProduct
//
//  Created by 高橋拓未 on 2021/11/23.
//

import UIKit
import RealmSwift

class Calendar2ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var homeNum: UILabel!
    @IBOutlet weak var context: UITextView!
    @IBOutlet weak var label: UILabel!
    
    var str : String?
    var str2 : String?
    var today = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.label.text = str
        label.numberOfLines = 0
        label.sizeToFit()
                
        context.delegate = self
        context.layer.borderColor = UIColor.black.cgColor
        context.layer.borderWidth = 1.0
        context.layer.cornerRadius = 10.0
        context.layer.masksToBounds = true
        
        self.context.isEditable = false
        self.context.isSelectable = false
        //self.view.addBackground(name: "homemokume")
        //self.context.addBackground(name: "homemokume")
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        
        DispatchQueue(label: "background").async {
                    let realm = try! Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)

            if let savedDiary = realm.objects(Nikki.self).filter("date == '\( self.str2!)'").last {
                        let context = savedDiary.textNikki
                        DispatchQueue.main.async {
                            self.context.text = context
                        }
                    }
            if let savedDiary = realm.objects(Nikki.self).filter("date == '\(self.str2!)'").last {
                        let homecount = savedDiary.home
                        DispatchQueue.main.async {
                            self.homeNum.text = String(homecount)
                       }
                    }
        }
    }
}
