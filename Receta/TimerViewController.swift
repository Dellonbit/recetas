//
//  TimerViewController.swift
//  Recipes
//
//  Created by arianne on 2016-01-09.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var notificationTitle: UITextField!
    @IBOutlet weak var timerView: UIDatePicker!
    var hour: Int = 0
    var min: Int = 0
    @IBOutlet weak var myTimePicker: UIPickerView!
    @IBOutlet weak var recipeTitle: UITextField!
    let pickerData = [["0","1","2","3","4","5","6","7","8","9", "10", "12", "13", "14", "15" ,"16 ","17","18","19","20","21","22","23","24"],["0","1","2","3","4","5","6","7","8","9", "10", "12", "13", "14", "15" ,"16 ","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTitle.delegate = self
        myTimePicker.delegate = self
        myTimePicker.dataSource = self
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    //MARK: DataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
        
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       switch component{
            case 0:
                print("hour \(pickerData[component][row])")
                hour = Int(pickerData[component][row])!
            case 1:
                print("second \(pickerData[component][row])")
                min = Int(pickerData[component][row])!
            default:
                print("nothing chosen")
            }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        if notificationTitle.text == "" {
            let msg = "Please enter a notification title"
            showMsg(msg)

        }
        else {
              print(notificationTitle.text)
            let secs = Double(60*min + 60*60*hour)
            
            let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
            
            if settings!.types == .None {
                let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
                return
            }
            
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: secs)
            notification.alertBody = notificationTitle.text
            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.applicationIconBadgeNumber = ++RecConvenience.sharedInstance().badgecount
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showMsg(msg:String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
