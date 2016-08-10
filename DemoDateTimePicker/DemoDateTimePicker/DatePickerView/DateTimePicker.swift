//
//  DateTimePicker.swift
//  DemoDateTimePicker
//
//  Created by Thái Bô Lão on 8/4/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

protocol DateTimePickerDelegate: class {
    func DateTimePiker(picker: DateTimePicker, doneButtonPressed doneButton: UIButton, selecedDate date: NSDate )
    func DateTimePiker(picker:DateTimePicker, cancelButtonPressed cancelButton: UIButton)
}

@IBDesignable
class DateTimePicker: UIView {
    // MARK: - CONSTANTS
    let nibName = "DateTimePicker"
    
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    let HOUR_COMPONENT = 0
    let MINUTE_COMPONENT = 1
    let DAY_COMPONENT = 2
    let MONTH_COMPONENT = 3
    let YEAR_COMPONENT = 4
    
    
    // MARK: - @IBInspectable
    private var materialKey = false
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 5.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 5.0
                self.layer.shadowOffset = CGSizeMake(0.0, 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1).CGColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var startYear: Int = 1900 {
        didSet {
            if startYear > endYear {
                startYear = 1900
            }
        }
    }
    @IBInspectable var endYear: Int = 2036 {
        didSet {
            if endYear <= startYear {
                endYear = 2036
            }
        }
    }
    
    
    // MARK: - VARIABLES
    var view: UIView!
    var hours = [String]()
    var minutes = [String]()
    var days = [String]()
    var months = [String]()
    var years = [String]()
    var maxDayOfMonth = 0
    
    var SINGLE_NUMBER_WIDTH: CGFloat = 50
    var MONTH_WIDTH: CGFloat = 80
    var YEAR_WIDTH: CGFloat = 70
    var COMPONENTS_HEIGHT: CGFloat = 50
    var DISTANCE_BETWEEN_TIME_AND_DATE: CGFloat = 20
    
    var currentHour = 0
    var currentMin = 0
    var currentDay = 0
    var currentMonth = 0
    var currentYear = 0
    
    var selectedDate = NSDate()
    var selectedDayRow = 0
    
    var delegate: DateTimePickerDelegate?
    
    
    // MARK: - INITIALIZATION
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        xibSetup()
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        initConstant()
        

    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let view: UIView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        return view
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        maxDayOfMonth = getNumberOfDayInMonth(NSDate())
        print("NumberOfDayInCurrentMonth: \(maxDayOfMonth)")
        updateCurrentDateFrom(NSDate())
        
        for i in 0...23 {
            hours.append("\(i)")
        }
        for i in 0...59 {
            if i < 10 {
                minutes.append("0\(i)")
            } else {
                minutes.append("\(i)")
            }
        }
        for i in startYear...endYear {
            years.append("\(i)")
        }
        for i in 1...maxDayOfMonth {
            days.append("\(i)")
        }
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        pickerView.selectRow(hours.count * 100 + currentHour, inComponent: HOUR_COMPONENT, animated: false)
        pickerView.selectRow(minutes.count * 100 + currentMin, inComponent: MINUTE_COMPONENT, animated: false)
        pickerView.selectRow(days.count * 100 + currentDay - 1, inComponent: DAY_COMPONENT, animated: false)
        pickerView.selectRow(months.count * 100 + currentMonth - 1, inComponent: MONTH_COMPONENT, animated: false)
        pickerView.selectRow(years.count * 100 + currentYear - startYear, inComponent: YEAR_COMPONENT, animated: false)
        
        selectedDayRow = minutes.count * 100 + currentMin
    }
    
    //MARK: - Caculater info of DATE
    func getNumberOfDayInMonth(date: NSDate) -> Int {
        let cal = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let days = cal.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        return days.length
    }
    func refreshDaysData(date: NSDate) {
        maxDayOfMonth = getNumberOfDayInMonth(date)
        days.removeAll()
        for i in 1...maxDayOfMonth {
            days.append("\(i)")
        }
        
    }
    func updateCurrentDateFrom(date: NSDate) {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        currentHour = (calendar?.component(NSCalendarUnit.Hour, fromDate: date))!
        currentMin = (calendar?.component(NSCalendarUnit.Minute, fromDate: date))!
        currentDay = (calendar?.component(NSCalendarUnit.Day, fromDate: date))!
        currentMonth = (calendar?.component(NSCalendarUnit.Month, fromDate: date))!
        currentYear = (calendar?.component(NSCalendarUnit.Year, fromDate: date))!
    
    }
    
    func initConstant () {
        //Designed base on iPhone6 screen
        let frameWidth = self.frame.size.width
        SINGLE_NUMBER_WIDTH = frameWidth / 8
        MONTH_WIDTH = 2 * SINGLE_NUMBER_WIDTH
        YEAR_WIDTH = SINGLE_NUMBER_WIDTH
        COMPONENTS_HEIGHT = (50 * frameWidth) / 375
        DISTANCE_BETWEEN_TIME_AND_DATE = SINGLE_NUMBER_WIDTH / 4
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        delegate?.DateTimePiker(self, cancelButtonPressed: sender as! UIButton)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        currentDay = pickerView.selectedRowInComponent(DAY_COMPONENT) % days.count + 1
        selectedDate = Date.from(currentYear, month: currentMonth , day: currentDay, hour: currentHour, minute: currentMin)
        delegate?.DateTimePiker(self, doneButtonPressed: sender as! UIButton, selecedDate: self.selectedDate)
    }
    

}

//MARK: - UIPickerViewDataSource
extension DateTimePicker: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 5
        
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case HOUR_COMPONENT:
            return hours.count * 1000
        case MINUTE_COMPONENT:
            return minutes.count * 1000
        case DAY_COMPONENT:
            return days.count * 1000
        case MONTH_COMPONENT:
            return months.count * 1000
        case YEAR_COMPONENT:
            return years.count * 1000
        default:
            print("wrong way")
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        //let view = UIView(frame: CGRectMake(0,0, 50,50))
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Avenir Next Condensed", size: 19)
        
        switch component {
        case HOUR_COMPONENT:
            view.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH, COMPONENTS_HEIGHT)
            label.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH, COMPONENTS_HEIGHT)
            //view.backgroundColor = UIColor.redColor()
            label.text =  hours[row % hours.count]
        case MINUTE_COMPONENT:
            view.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH + DISTANCE_BETWEEN_TIME_AND_DATE, COMPONENTS_HEIGHT)
            label.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH, COMPONENTS_HEIGHT)
            //view.backgroundColor = UIColor.blueColor()
            label.text = minutes[row % minutes.count]
            let twodotsLabel = UILabel(frame: CGRectMake(-5,0,10, 50))
            twodotsLabel.text = ":"
            twodotsLabel.font = UIFont(name: "Avenir Next Condensed", size: 19)
            view.addSubview(twodotsLabel)
            if row == selectedDayRow {
                twodotsLabel.textColor = UIColor.blackColor()
            } else {
                twodotsLabel.textColor = UIColor.whiteColor()
            }
        case DAY_COMPONENT:
            view.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH, COMPONENTS_HEIGHT)
            label.frame = CGRectMake(0, 0, SINGLE_NUMBER_WIDTH, COMPONENTS_HEIGHT)
            //view.backgroundColor = UIColor.redColor()
            label.text = days[row % days.count]
        case MONTH_COMPONENT:
            view.frame = CGRectMake(0, 0, MONTH_WIDTH, COMPONENTS_HEIGHT)
            label.frame = CGRectMake(0, 0, MONTH_WIDTH, COMPONENTS_HEIGHT)
            //view.backgroundColor = UIColor.yellowColor()
            label.text = months[row % months.count]
        case YEAR_COMPONENT:
            view.frame = CGRectMake(0, 0, YEAR_WIDTH, COMPONENTS_HEIGHT)
            label.frame = CGRectMake(0, 0, YEAR_WIDTH, COMPONENTS_HEIGHT)
            //view.backgroundColor = UIColor.blueColor()
            label.text = years[row % years.count]
        default:
            print("something wrong")
            label.text = ""
        }
        
        
        
        return view
        
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        switch component {
        case HOUR_COMPONENT:
            return SINGLE_NUMBER_WIDTH
            
        case MINUTE_COMPONENT:
            return SINGLE_NUMBER_WIDTH + DISTANCE_BETWEEN_TIME_AND_DATE
            
        case DAY_COMPONENT:
            return SINGLE_NUMBER_WIDTH
            
        case MONTH_COMPONENT:
            return MONTH_WIDTH
            
        case YEAR_COMPONENT:
            return YEAR_WIDTH
            
        default:
            return 0
        }
        
    }

}

//MARK: - UIPickerView Delegate
extension DateTimePicker: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case HOUR_COMPONENT:
            currentHour = row % hours.count
            print("row: \(row)")
            
        case MINUTE_COMPONENT:
            selectedDayRow = row
            pickerView.reloadComponent(MINUTE_COMPONENT)
            currentMin = row % minutes.count
            print("row: \(row)")
            
        case DAY_COMPONENT:
            currentDay = (row % days.count) + 1
            print("row: \(row)")
            
        case MONTH_COMPONENT:
            currentMonth = (row % months.count) + 1
            print("row: \(row)")
            
        case YEAR_COMPONENT:
            currentYear = startYear + (row % years.count)
            print("row: \(row)")
            
        default:
            print("Default")
        }
        
        let tempSelectedDate = Date.from(currentYear, month: currentMonth , day: 2, hour: 1, minute: 0)
        maxDayOfMonth = getNumberOfDayInMonth(tempSelectedDate)
        if currentDay > getNumberOfDayInMonth(tempSelectedDate) {
            days.removeAll()
            for i in 1...maxDayOfMonth {
                days.append("\(i)")
            }
            pickerView.reloadComponent(DAY_COMPONENT)
            currentDay = maxDayOfMonth
           
        }
        if days.count < maxDayOfMonth {
            days.removeAll()
            for i in 1...maxDayOfMonth {
                days.append("\(i)")
            }
            pickerView.reloadComponent(DAY_COMPONENT)
        }
         selectedDate = Date.from(currentYear, month: currentMonth, day: currentDay , hour: currentHour, minute: currentMin)
    }

}


// MARK:- UIView Extension
extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.init(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }

}

class Date {
    
    class func from(year:Int, month:Int, day:Int, hour: Int, minute: Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute
        
        let gregorian = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let date = gregorian!.dateFromComponents(c)
        return date!
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
}


