//
//  DateTimePicker.swift
//  DemoDateTimePicker
//
//  Created by Thái Bô Lão on 8/4/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

@IBDesignable
class DateTimePicker: UIView {
    // MARK: - CONSTANTS
    let nibName = "DateTimePicker"
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
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
    
    
    // MARK: - VARIABLES
    var view: UIView!
    var hours = [String]()
    var minutes = [String]()
    let twodots = [":"]
    var days = [String]()
    var months = [String]()
    var years = [String]()
    
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        for i in 1991...2036 {
            years.append("\(i)")
        }
        for i in 1...30 {
            days.append("\(i)")
        }
        
        months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
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
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let view: UIView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        return view
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
    }
    

}

//MARK: - UIPickerViewDataSource
extension DateTimePicker: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6
        
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return 1
        case 2:
            return minutes.count
        case 3:
            return days.count
        case 4:
            return months.count
        case 5:
            return years.count
        default:
            print("wrong way")
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hours[row]
        case 1:
            return twodots[row]
        case 2:
            return minutes[row]
        case 3:
            return days[row]
        case 4:
            return months[row]
        case 5:
            return years[row]
        default:
            print("wrong way")
            return ""
        }
    }
    
    

}

//MARK: - UIPickerView Delegate
extension DateTimePicker: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            print("\(hours[row])")
        case 1:
            print("\(twodots[row])")
        case 2:
            print("\(minutes[row])")
        case 3:
            print("\(days[row])")
        case 4:
            print("\(months[row])")
        case 5:
            print("\(years[row])")
        default:
            print("wrong way")
        }
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


