//
//  MainVC.swift
//  DemoDateTimePicker
//
//  Created by Thái Bô Lão on 8/4/16.
//  Copyright © 2016 TBLStudio. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var dateTimePicker: DateTimePicker!
    
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        self.dateTimePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainVC: DateTimePickerDelegate {
    func DateTimePiker(picker: DateTimePicker, cancelButtonPressed cancelButton: UIButton) {
        print("Cancel")
    }
    
    func DateTimePiker(picker: DateTimePicker, doneButtonPressed doneButton: UIButton, selecedDate date: NSDate) {
        print("Done")
        dateLabel.text = date.toString()
    }
}