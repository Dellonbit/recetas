//
//  RecipeEditorViewController.swift
//  Recipes
//
//  Created by arianne on 2016-01-15.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit
import CoreData

class RecipeEditorViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var indtorLabel: UILabel!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeCookTime: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var ingdAndPrep: UITextView!
    var activeField: UITextField!
    var ingdts = ""
    var isInstrPressed = ""
    var inst = ""
    var arrdata: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeName.delegate = self
        recipeCookTime.delegate = self
        ingdAndPrep.delegate = self
        recipeName.tag = 1
        recipeCookTime.tag = 2
        ingdAndPrep.tag = 3
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
        view.layer.cornerRadius = 10
        //disable camera on simulator
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cameraButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
   
    
    // pick image from folder
    @IBAction func pickImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            recipeCookTime.contentMode = .ScaleAspectFit
            recipeImage.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        view.endEditing(true)
        recipeCookTime.resignFirstResponder()
        recipeName.resignFirstResponder()
        //inst = ingdAndPrep.text
        ingdAndPrep.resignFirstResponder()
        
        if recipeImage.image == nil {
            //var imgdata = NSURL(string: <#T##String#>))
            let msg = "Ooops! looks like you forgot to add a recipe image."
            showMsg(msg)
        }
        else if ((recipeName.text == nil) || (recipeCookTime.text == nil) || (ingdAndPrep.text == nil) ) {
            let msg = "Ooops! looks like you forgot to fill one of the required fields."
            showMsg(msg)
        }
        else if (inst == ""){
            let msg = "you forgot to enter the instructions"
            showMsg(msg)
        }
        else if (ingdts == "" ){
            let msg = "you forgot to enter ingrediants "
            showMsg(msg)
        }
            
        else {
            let img =  UIImagePNGRepresentation(recipeImage.image!)
                
            //save photo in core data
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let savedRecipe = Recipe(recpName: recipeName.text!, recpCookTime: recipeCookTime.text!, pic: img!, indPrep: ingdts, inst: inst, context: managedContext)
            RecConvenience.sharedInstance().recipeList.append(savedRecipe)
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        recipeCookTime.resignFirstResponder()
        recipeName.resignFirstResponder()
        return true
    }
    
    @IBAction func recipeSteps(sender: AnyObject) {
        
        
        if indtorLabel.text == "Enter ingredients here"  {
            //inst = ingdAndPrep.text
            ingdAndPrep.text = inst
            indtorLabel.text = "Enter instructions here"
        }
        else if indtorLabel.text == "Enter instructions here" {
            //ingdts = ingdAndPrep.text
            ingdAndPrep.text = ingdts
            indtorLabel.text = "Enter ingredients here"
        }
        
        //check for when to hide label
        if inst != "" || ingdts != "" {
            indtorLabel.hidden = true
        }
        else {
            indtorLabel.hidden = false
            
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //ingdAndPrep.text = ""
        indtorLabel.hidden = true
        ingdAndPrep.textAlignment = .Left
        if indtorLabel.text == "Enter ingredients here" {
            if ingdts == ""{
                ingdAndPrep.text = ingdts
            }
            else {
                ingdAndPrep.text = ingdts
            }
        }
            
        else if  indtorLabel.text == "Enter instructions here" {
           ingdAndPrep.text = inst
            if ingdts == ""{
                ingdAndPrep.text = inst
            }
            else {
                ingdAndPrep.text = inst
                
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if indtorLabel.text == "Enter ingredients here" {
           ingdts = ingdAndPrep.text
           ingdAndPrep.text = ""
           indtorLabel.text = "Enter instructions here"
           indtorLabel.hidden = false
        }
            
        else if indtorLabel.text == "Enter instructions here" {
            inst = ingdAndPrep.text
            if inst != " " {indtorLabel.hidden = true
            }
            else {
                indtorLabel.hidden = false
            }
            //ingdAndPrep.text = ""
            indtorLabel.text = "Enter ingredients here"
        
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Linktxt.resignFirstResponder()
        recipeCookTime.resignFirstResponder()
        recipeName.resignFirstResponder()
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,  name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,  name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
 // http://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder() {
                return subView
            }
            
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
    
    func keyboardWillShow(notification: NSNotification) {

        let firstResponder = findFirstResponder(inView: self.view)
        var aRect = self.view.bounds
        aRect.size.height -= getKeyboardHeight(notification)
        print(firstResponder?.tag)
        if (firstResponder?.tag == 3){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var aRect = self.view.bounds
        aRect.size.height -= getKeyboardHeight(notification)
            view.frame.origin.y  = 0
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    @IBAction func cancelAction(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showMsg(msg:String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
