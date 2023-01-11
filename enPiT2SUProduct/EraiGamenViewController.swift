//
//  EraiGamenViewController.swift
//  enPiT2SUProduct
//
//  Created by ysako on 2021/11/17.
//
// createWeekSumpleDataにより週のサンプルデータを作成

import UIKit
import Charts
import RealmSwift

struct BarChartModel {
    let value: Int
    let name: String
}

class EraiGamenViewController: UIViewController ,ChartViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var allEraiCount: UILabel!
    @IBOutlet weak var achievementRate: UILabel!
    @IBOutlet weak var eraiDateFirst: UILabel!
    @IBOutlet weak var eraiCountFirst: UILabel!
    @IBOutlet weak var eraiDateSecond: UILabel!
    @IBOutlet weak var eraiCountSecond: UILabel!
    @IBOutlet weak var eraiDateThird: UILabel!
    @IBOutlet weak var eraiCountThird: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var barChartView: BarChartView!
    var barItems:Array<(Int,String)> = []
    let useSampleData = false //サンプルデータを使う場合trueに変更
    
    //月のサンプルデータ
    var sampleData = [(30,"20210801"),(20,"20210902"),(15,"20211003"),(20,"20211104"),(11,"20211205"),(12,"20220101"),(13,"20220104")]
    //週のサンプルデータ
    var weekSumpleData = [(10,"01/15"),(15,"01/16"),(20,"01/17"),(5,"01/18"),(9,"01/19"),(25,"01/20"),(15,"01/21")]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //realmよりデータ作成
        barItems = createBarItems()
        
        //デバック
        for i in 0..<sampleData.count{
            barItems.append(sampleData[i])
        }
        barItems = weekBarItemsUpdate(data: barItems)
        //サンプルデータを用いる
        if useSampleData == true{
            barItems = createWeekSumpleData()
        }
        // DBのファイルの場所
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        
        //データ作成
        let data = createBarChartData(of: barItems.map({BarChartModel(value: $0.0, name: $0.1)}))
        //barChartViewの設定
        //アニメーション
        barChartView.animate(yAxisDuration: 2)
        //名前の表示
        barChartView.xAxis.labelCount = barItems.count
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barItems.map({$0.1}))
        //細かい設定
        //最小値
        barChartView.leftAxis.axisMinimum = 0.0
        //最大値
        barChartView.leftAxis.axisMaximum = Double(barItems.map({ $0.0 }).max()!) + 1
        // グリッドやy軸を非表示
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
        barChartView.leftAxis.labelCount = 4
        barChartView.rightAxis.enabled = false
        // 凡例を非表示にする
        barChartView.legend.enabled = false
        // ズームできないようにする
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        //タップしてハイライトしないようにする
        barChartView.highlightPerTapEnabled = false
        
        //fontの設定
        barChartView.xAxis.labelFont = UIFont(name: "Noteworthy-Bold", size: 11)!
        
        //グラフの背景色(グレーに設定)
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.2)
        barChartView.data = data
        contentView.addSubview(barChartView)
        
        //Labelを更新
        updateAllLabel()
        
    }
    

    //データ作成
    private func createBarChartData(of items: [BarChartModel]) -> BarChartData {
        let entries: [BarChartDataEntry] = items.enumerated().map {
            let (i, item) = $0
            return BarChartDataEntry(x: Double(i), y: Double(item.value))
        }
        let barChartDataSet = BarChartDataSet(entries: entries, label: "Label")
        barChartDataSet.colors = ChartColorTemplates.colorful()
        let barChartData = BarChartData(dataSet: barChartDataSet)
        
        //上の数字の書式設定
        barChartDataSet.valueFormatter = ValueFormatter(of: items)
        barChartDataSet.valueFont = UIFont.systemFont(ofSize: 11)
        return barChartData
    }
    
    //数字の書式設定
    class ValueFormatter: IValueFormatter {
        let items: [BarChartModel]
        init(of items: [BarChartModel]) {
            self.items = items
        }
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return "\(Int(value))"
        }
    }
    
    //タップアクション
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let axisFormatter = chartView.xAxis.valueFormatter!
        let label = axisFormatter.stringForValue(entry.x, axis: nil)
        print(label, Int(entry.y))
        //画面遷移
        let DetailNikkiViewCountroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailNikkiViewCountroller") as! DetailNikkiViewCountroller
        //変数受け渡し
        DetailNikkiViewCountroller.date = label
        self.present(DetailNikkiViewCountroller, animated: true, completion: nil)
    }
 
    
    //barItemsの作成
    func createBarItems()->Array<(Int, String)>{
        var barItems:Array<(Int, String)> = []
        var temp:(Int, String) //一時保管用
        var tempBarItems:Array<(Int, String)> = []//作業する配列
        //realmの追加
        let realm = try!Realm()
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        for nikki in nikki {
            temp = (nikki.home, nikki.date)
            barItems.append(temp)
        }
        //tempに代入してソート
        tempBarItems = barItems.sorted(by: { (a, b) -> Bool in
            return a.1 < b.1
        })
        barItems = tempBarItems
        return barItems
    }
    //週のグラフ
    func weekBarItemsUpdate(data: Array<(Int, String)>) -> Array<(Int, String)>{
        
        var updatedBarItems:Array<(Int, String)> = [] //更新後の配列
        var today = getNowTime()
        var month = ""
        var day = ""
        var flag = false
        var tempItems:(Int,String) = (0,"")
        var arrayDay:Array<String> = []
        for _ in 0..<6{
            today = getYesterday(date: today)
            arrayDay.insert(today, at: 0)
        }
        arrayDay.append(getNowTime())
        print(arrayDay)
        //realmの追加
        let realm = try!Realm()
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        for i in 0..<7{
            for nikki in nikki{
                if(nikki.date == arrayDay[i]){
                    month = getMonth(date: arrayDay[i])
                    day = getDay(date: arrayDay[i])
                    tempItems = (nikki.home, month + "/" + day)
                    flag = true
                }
            }
            if(flag == false){
                month = getMonth(date: arrayDay[i])
                day = getDay(date: arrayDay[i])
                tempItems = (0, month + "/" + day)
            }
            updatedBarItems.append(tempItems)
            flag = false
        }
        return updatedBarItems
    }
    //月のグラフ
    func barItemsUpdate(data: Array<(Int, String)>) -> Array<(Int, String)>{
        var updatedBarItems:Array<(Int, String)> = [] //更新後の配列
        var returnBarItems:Array<(Int, String)> = []//returnする配列
        updatedBarItems = getYearMonthGood(data: data) //年月のいいね数
        //データのカウントを6に変更
        var barItemsCount = updatedBarItems.count
        //6より大きいとき削除
        while barItemsCount > 6{
            updatedBarItems.removeFirst()
            barItemsCount -= 1
        }

        let nowYearMonth = getYearMonth(date: getNowTime())//現在の月を取得
        let nowYear = Int(nowYearMonth.dropLast(2))! //現在の年
        let nowMonth = Int(nowYearMonth.dropFirst(4))!//現在の月
        var startMonth:Int
        var startYear:Int
        var startYearMonth:String
        var monthFlag = false //startMonthがあるかないか
        if (1 <= nowMonth && nowMonth <= 4){
            startMonth = (nowMonth + 7) % 12
            startYear = nowYear - 1
        }else if (nowMonth == 5){
            startMonth = 12
            startYear = nowYear - 1
        }else{
            startMonth = nowMonth - 5
            startYear = nowYear
        }
        if (1 <= startMonth && startMonth <= 9){
            startYearMonth = String(startYear) + "0" + String(startMonth)
        }else{
            startYearMonth = String(startYear) + String(startMonth)
        }
        
        while true{

            for i in 0..<updatedBarItems.count{
                if updatedBarItems[i].1 == startYearMonth{
                    returnBarItems.append((updatedBarItems[i].0,startYearMonth.dropFirst(4) + "月" ))
                    monthFlag = true
                }
            }
            if monthFlag == true {
                monthFlag = false
            }else{
                returnBarItems.append((0,startYearMonth.dropFirst(4) + "月"))
            }
            if(1 <= startMonth && startMonth <= 11){
                startMonth += 1
            }else{
                startMonth = 1
                startYear += 1
            }
            if (1 <= startMonth && startMonth <= 9){
                startYearMonth = String(startYear) + "0" + String(startMonth)
            }else{
                startYearMonth = String(startYear) + String(startMonth)
            }
            if startYearMonth == nowYearMonth{
                break
            }
        }
        for i in 0..<updatedBarItems.count{
            if updatedBarItems[i].1 == startYearMonth{
                returnBarItems.append((updatedBarItems[i].0,startYearMonth.dropFirst(4) + "月" ))
                monthFlag = true
            }
        }
        if monthFlag == true {
            monthFlag = false
        }else{
            returnBarItems.append((0,startYearMonth.dropFirst(4) + "月"))
        }
        return returnBarItems
    }
    //年月を取得
    func getYearMonth(date:String)->String {
        let yearMonth:String = String(date.dropLast(2))
        return yearMonth
    }
    //月を取得
    func getMonth(date:String)->String{
        let month:String = String(date.dropFirst(4).dropLast(2))
        return month
    }
    //年を取得
    func getYear(date:String)->String{
        let year:String = String(date.dropLast(4))
        return year
    }
    //日を取得
    func getDay(date:String)->String{
        let day:String = String(date.dropFirst(6))
        return day
    }
    //現在時刻を取得
    func getNowTime()->String{
        let date = Date()
        let formatterDay = DateFormatter()
        var today:String = ""
        formatterDay.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        formatterDay.timeZone = TimeZone(identifier: "Asia/Tokyo")

        today = (formatterDay.string(from: date))
        
        today = today.replacingOccurrences(of: "/", with: "")
            
        return today
    }
    //昨日の日付を返す
    private func getYesterday(date: String) -> String {
        var year = getYear(date: date)
        var month = getMonth(date: date)
        var day = getDay(date: date)
        var temp = 0
        
        if( day == "01" && month == "01"){
            temp = Int(year)! - 1
            year = String(temp)
            month = "12"
            day = "31"
        }else if( day == "01" && (month == "02" || month == "04" || month == "06" || month == "09" || month == "11")){
            day = "31"
            temp = Int(month)! - 1
            month = String(temp)
        }else if( day == "01" && month == "03" && Int(year)! % 4 != 0){
            day = "28"
            month = "02"
        }else if( day == "01" && month == "03" && Int(year)! % 4 == 0){
            day = "29"
            month = "02"
        }else if (day == "01"){
            day = "30"
            temp = Int(month)! - 1
            month = String(temp)
        }else{
            day = String(Int(day)! - 1)
        }
        
        day = editMonth(data: day)
        month = editMonth(data: month)
        return (year + month + day)
    }
    //月の形を変形
    private func editMonth(data:String) -> String{
        if data == "0"{
            return "12"
        }
        else if (data == "0" || data == "1" || data == "2" || data == "3" || data == "4" || data == "5" || data == "6" || data == "7" || data == "8" || data == "9"){
            return "0" + data
        }
        return data
    }
    //Array<(月のいいね数,年月)>の形に変更
    //(1,"202101")
    private func getYearMonthGood (data: Array<(Int, String)>) -> Array<(Int, String)> {
        var updatedBarItems:Array<(Int, String)> = [] //更新後の配列
        var tempBarItems:Array<(Int, String)> = []//作業する配列
        
        //tempに代入してソート
        tempBarItems = data.sorted(by: { (a, b) -> Bool in
            return a.1 < b.1
        })
        var tempItems:(Int, String) //一時保管
        var oldMonth:String = ""
        var newMonth:String = ""
        let length = Int(data.count) //データの数
        var count = 0 //えらいカウント
        var month = "" //月の名前
        
        for i in (0..<length) {
            tempItems = tempBarItems[i]
            newMonth = getYearMonth(date: tempItems.1)
            //月が同じ場合
            if oldMonth == newMonth {
                //カウントを更新
                count += tempItems.0
            }
            //違う場合
            else {
                //oldMonthのデータを配列に追加
                updatedBarItems.append( (count,month))
                //月を更新
                month = getYearMonth(date: tempItems.1)
                //カウントを更新
                count = tempItems.0
                //oldMonthを更新
                oldMonth = getYearMonth(date: tempItems.1)
            }
        }
        //データの細かい処理
        //oldMonthのデータを配列に追加
        updatedBarItems.append( (count,month))
        //最初のデータ削除
        updatedBarItems.removeFirst()
        
        return updatedBarItems
    }
    //Array<(月のいいね数,月)>の形に変更
    //(1,"01")
    
    private func getMonthGood(data:Array<(Int,String)>) -> Array<(Int,String)>{
        let length = Int(data.count) //データの数
        var updatedBarItems:Array<(Int, String)> = [] //更新後の配列
        var tempItems:(Int,String)
        var month = ""//月
        for i in 0..<length{
            month = String(data[i].1.dropFirst(4))
            tempItems = (data[i].0, month)
            updatedBarItems.append(tempItems)
        }
        return updatedBarItems
    }
    //全てのラベルを更新
    private func updateAllLabel () -> (){
        updateAllEraiCount()
        updateAchivementRate()
        updateOtherLabel()
    }
    //allEraiCOuntを更新
    private func updateAllEraiCount () -> () {
        //realmの追加
        let realm = try!Realm()
        var count = 0
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        for nikki in nikki {
            count += nikki.home
        }
        if useSampleData == true{
            for weekSumpleData in weekSumpleData{
                count += weekSumpleData.0
            }
        }
        allEraiCount.text = String(count) + "回"
    }
    //achivementRateを更新
    private func updateAchivementRate () -> (){
        var achivementRate = 0
        //realmの追加
        let realm = try!Realm()
        var realmCount = 0 //全てのrealmの数
        var targetCount = 0 //目標を達成した数
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        for nikki in nikki {
            realmCount += 1
            if nikki.home >= nikki.targetScore {
                targetCount += 1
            }
        }
        if realmCount != 0{
            achivementRate = 100 * targetCount / realmCount
        }else{
            achivementRate = 0
        }
        if useSampleData == true{
            achivementRate = 75
        }
        achievementRate.text = String(achivementRate) + "%"
    }
    //その他のラベルを更新
    private func updateOtherLabel () -> (){
        var firstHomeCount = 0 //一番えらいを押された回数
        var firstHomeDate = "" //一番えらいを押された日
        var secondHomeCount = 0 //二番目にえらいを押された回数
        var secondHomeDate = "" //二番目にえらいを押された日
        var thirdHomeCount = 0 //三番目にえらいを押された回数
        var thirdHomeDate = "" //三番目にえらいを押された日
        var year = ""
        var month = ""
        var day = ""
        //realmの追加
        let realm = try!Realm()
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        //1位
        for nikki in nikki {
            if nikki.home > firstHomeCount {
                firstHomeCount = nikki.home
                firstHomeDate = nikki.date
            }
        }
        //2位
        for nikki in nikki {
            if nikki.home > secondHomeCount && nikki.home != firstHomeCount{
                secondHomeCount = nikki.home
                secondHomeDate = nikki.date
            }
        }
        //3位
        for nikki in nikki {
            if nikki.home > thirdHomeCount && nikki.home != firstHomeCount && nikki.home != secondHomeCount{
                thirdHomeCount = nikki.home
                thirdHomeDate = nikki.date
            }
        }
        //ラベル更新
        if firstHomeCount != 0{
            year = getYear(date: firstHomeDate)
            month = getMonth(date: firstHomeDate)
            if (month == "1" || month == "2" || month == "3" || month == "4" || month == "5" || month == "6" || month == "7" || month == "8" || month == "9"){
                month = " " + month
            }
            day = getDay(date: firstHomeDate)
            eraiDateFirst.text = year + "/" + month + "/" + day
            eraiCountFirst.text = String(firstHomeCount) + "回"
        }
        if secondHomeCount != 0{
            year = getYear(date: secondHomeDate)
            month = getMonth(date: secondHomeDate)
            if (month == "1" || month == "2" || month == "3" || month == "4" || month == "5" || month == "6" || month == "7" || month == "8" || month == "9"){
                month = " " + month
            }
            day = getDay(date: secondHomeDate)
            eraiDateSecond.text = year + "/" + month + "/" + day
            eraiCountSecond.text = String(secondHomeCount) + "回"
        }
        if thirdHomeCount != 0{
            year = getYear(date: thirdHomeDate)
            month = getMonth(date: thirdHomeDate)
            if (month == "1" || month == "2" || month == "3" || month == "4" || month == "5" || month == "6" || month == "7" || month == "8" || month == "9"){
                month = " " + month
            }
            day = getDay(date: thirdHomeDate)
            eraiDateThird.text = year + "/" + month + "/" + day
            eraiCountThird.text = String(thirdHomeCount) + "回"
        }
        if useSampleData == true {
            eraiDateFirst.text = "2021/08/13"
            eraiCountFirst.text = "30回"
            eraiDateSecond.text = "2021/12/20"
            eraiCountSecond.text = "25回"
            eraiDateThird.text = "2022/01/19"
            eraiCountThird.text = "23回"
            
        }
    }
    private func realmUpdate (count: Int, mode: Int, today: String){
        let realm = try! Realm()
        let Data = Nikki()
        
        let Alldata = realm.objects(Nikki.self)
        let predicate = NSPredicate(format: "date == %@", today)
        
        let results = Alldata.filter(predicate).first
        
        //なければ新規作成、あるなら編集
        if(results != nil){
            try! realm.write{
                results!.home += count
                results!.status = true
                if(mode == 0){
                    results!.botanCount += count
                }else if (mode == 1) {
                    results!.todoCount += count
                }else if (mode == 2) {
                    results!.autoEraiCount += count
                }
            }

        }else {
            Data.textNikki = ""
            Data.date = today
            Data.home = count
            Data.status = true
            results!.botanCount = 0
            results!.todoCount = 0
            results!.autoEraiCount = 0
            if(mode == 0){
                results!.botanCount = count
            }else if (mode == 1) {
                results!.todoCount = count
            }else if (mode == 2) {
                results!.autoEraiCount = count
            }
            try! realm.write{
                realm.add(Data)
            }
        }
    }
    //週のサンプルデータを作成
    private func createWeekSumpleData() -> Array<(Int,String)> {
        var tempData = weekSumpleData
        //realmの追加
        let realm = try!Realm()
        //realmの参照
        let nikki = realm.objects(Nikki.self)
        for nikki in nikki {
            if nikki.date == "20220121" {
                tempData.removeLast()
                tempData.append((nikki.home,"01/21"))
            }
        }
        return tempData
    }
    //セグメントコントロール
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                //realmよりデータ作成
                barItems = createBarItems()
                barItems = weekBarItemsUpdate(data: barItems)
                //サンプルデータを用いる
                if useSampleData == true{
                    barItems = createWeekSumpleData()
                }
                // DBのファイルの場所
                print(Realm.Configuration.defaultConfiguration.fileURL!)
                
                //データ作成
                let data = createBarChartData(of: barItems.map({BarChartModel(value: $0.0, name: $0.1)}))
                //barChartViewの設定
                //アニメーション
                barChartView.animate(yAxisDuration: 2)
                //名前の表示
                barChartView.xAxis.labelCount = barItems.count
                barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11)
                barChartView.xAxis.labelPosition = .bottom
                barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barItems.map({$0.1}))
                //細かい設定
                //最小値
                barChartView.leftAxis.axisMinimum = 0.0
                //最大値
                barChartView.leftAxis.axisMaximum = Double(barItems.map({ $0.0 }).max()!) + 1
                // グリッドやy軸を非表示
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.leftAxis.enabled = true
                barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
                barChartView.leftAxis.labelCount = 4
                barChartView.rightAxis.enabled = false
                // 凡例を非表示にする
                barChartView.legend.enabled = false
                // ズームできないようにする
                barChartView.pinchZoomEnabled = false
                barChartView.doubleTapToZoomEnabled = false
                //タップしてハイライトしないようにする
                barChartView.highlightPerTapEnabled = false
                
                //グラフの背景色(グレーに設定)
                barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.2)
                barChartView.data = data
                contentView.addSubview(barChartView)
                
                //Labelを更新
                updateAllLabel()
            case 1:
                //realmよりデータ作成
                barItems = createBarItems()
                //デバック
                if useSampleData == true{
                    barItems.append(contentsOf: sampleData)
                }
                barItems = barItemsUpdate(data: barItems)
                // DBのファイルの場所
                print(Realm.Configuration.defaultConfiguration.fileURL!)
                
                //データ作成
                let data = createBarChartData(of: barItems.map({BarChartModel(value: $0.0, name: $0.1)}))
                //barChartViewの設定
                //アニメーション
                barChartView.animate(yAxisDuration: 2)
                //名前の表示
                barChartView.xAxis.labelCount = barItems.count
                barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11)
                barChartView.xAxis.labelPosition = .bottom
                barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: barItems.map({$0.1}))
                //細かい設定
                //最小値
                barChartView.leftAxis.axisMinimum = 0.0
                //最大値
                barChartView.leftAxis.axisMaximum = Double(barItems.map({ $0.0 }).max()!) + 1
                // グリッドやy軸を非表示
                barChartView.xAxis.drawGridLinesEnabled = false
                barChartView.leftAxis.enabled = true
                barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11)
                barChartView.leftAxis.labelCount = 4
                barChartView.rightAxis.enabled = false
                // 凡例を非表示にする
                barChartView.legend.enabled = false
                // ズームできないようにする
                barChartView.pinchZoomEnabled = false
                barChartView.doubleTapToZoomEnabled = false
                //タップしてハイライトしないようにする
                barChartView.highlightPerTapEnabled = false
                
                //グラフの背景色(グレーに設定)
                barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 0.2)
                barChartView.data = data
                contentView.addSubview(barChartView)
                
                //Labelを更新
                updateAllLabel()
            default:
                print("error!")
        }
        self.reloadInputViews()
    }
    
}



