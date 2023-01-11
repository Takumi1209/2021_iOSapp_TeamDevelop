//
//  CalendarViewController.swift
//  enPiT2SUProduct
//
//  Created by 高橋拓未 on 2021/11/17.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    @IBOutlet var calendar: FSCalendar!
    
    var today = ""
    var datesWithStatus: Set<Bool> = []
    var checkWithStatus: Set<Bool> = [true]
    var erai = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        //calendar.scope = .week   //週表示
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        self.calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        self.calendar.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
        self.calendar.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
        //self.calendar.addBackground(name: "homemokume")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
        fileprivate lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

        // 祝日判定を行い結果を返すメソッド(True:祝日)
        func judgeHoliday(_ date : Date) -> Bool {
            //祝日判定用のカレンダークラスのインスタンス
            let tmpCalendar = Calendar(identifier: .gregorian)

            // 祝日判定を行う日にちの年、月、日を取得
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)

            // CalculateCalendarLogic()：祝日判定のインスタンスの生成
            let holiday = CalculateCalendarLogic()

            return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        }
        // date型 -> 年月日をIntで取得
        func getDay(_ date:Date) -> (Int,Int,Int){
            let tmpCalendar = Calendar(identifier: .gregorian)
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            return (year,month,day)
        }

        //曜日判定(日曜日:1 〜 土曜日:7)
        func getWeekIdx(_ date: Date) -> Int{
            let tmpCalendar = Calendar(identifier: .gregorian)
            return tmpCalendar.component(.weekday, from: date)
        }

        // 土日や祝日の日の文字色を変える
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            //祝日判定をする（祝日は赤色で表示する）
            if self.judgeHoliday(date){
                return UIColor.red
            }

            //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {   //日曜日
                return UIColor.red
            }
            else if weekday == 7 {  //土曜日
                return UIColor.blue
            }

            return nil
        }
    
    //選択された日付を表示
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYY年MM月dd日"
        let string = formatter.string(from: date)
        print("\(string)")
        formatter.dateFormat = "yyyyMMdd"
        let string2 = formatter.string(from: date)
        //画面遷移
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondController = storyboard?.instantiateViewController(withIdentifier: "Insert") as! Calendar2ViewController
        SecondController.str = string
        SecondController.str2 = string2
        present(SecondController, animated: true, completion: nil)
    }
    
/*
    //画像をつける関数
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let maru1 = UIImage(named: "maru3")
        let Resize:CGSize = CGSize.init(width: 26, height: 38) // サイズ指定
        let maru1Resize = maru1?.resize(size: Resize)
        return maru1Resize
    }
*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
    }
    // イメージ画像をつける
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let calendarDay = formatter.string(from: date)
       
        let maru1 = UIImage(named: "maru1")
        let maru2 = UIImage(named: "maru2")
        let maru3 = UIImage(named: "maru3")
        let maru4 = UIImage(named: "maru4")
        let maru5 = UIImage(named: "maru5")
        let Resize:CGSize = CGSize.init(width: 56, height: 62) // サイズ指定
        let maru1Resize = maru1?.resize(size: Resize)
        let maru2Resize = maru2?.resize(size: Resize)
        let maru3Resize = maru3?.resize(size: Resize)
        let maru4Resize = maru4?.resize(size: Resize)
        let maru5Resize = maru5?.resize(size: Resize)
        // Realmオブジェクトの生成
        let realm = try! Realm()
        // 参照（全データを取得）
        let maruone = realm.objects(Nikki.self).filter("date == '\(calendarDay)'")
    
        if maruone.count > 0 {
            for i in 0..<maruone.count {
                if i == 0 {
                    datesWithStatus = [maruone[i].status]
                    erai = maruone[i].home
                } else {
                    datesWithStatus.insert(maruone[i].status)
                }
            }
        } else {
            datesWithStatus = []
        }
        if datesWithStatus == checkWithStatus {
            if 1...10 ~= erai{
            return maru1Resize
            }
            if 11...20 ~= erai{
            return maru2Resize
            }
            if 21...30 ~= erai{
            return maru3Resize
            }
            if 31...40 ~= erai{
            return maru4Resize
            }
            if 41 <= erai{
            return maru5Resize
            }
        }
       return nil
    }
}

// UIImageのリサイズ
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
//背景
extension UIView {
    func addBackground(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)

        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
}
