//
//  ViewController.swift
//  Recipes
//
//  Created by arianne on 2016-01-06.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit
import  CoreData

class ListRecipeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet
    var tableView: UITableView!
    var newarraytt: NSArray!
    var ingredientText: String!
    var indexlocator: Int!
    var y :CGFloat = 0.0
    var x :CGFloat = 0.0
    var wait: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "recImage")
        tableView.delegate = self
       
        //activity indicator params
        let width: CGFloat = 200.0
        let height: CGFloat = 50.0
        x = self.view.frame.width/2.0 - width/2.0
        y = self.view.frame.height/2.0 - height/2.0
    }

    override func viewWillAppear(animated: Bool) {
        //view.layer.cornerRadius = 10
        self.title = "Recipes"
        RecConvenience.sharedInstance().ingdprep = ""
        
        ///create uiview
        let viewArea = UIView(frame: CGRect(x: x, y: y, width: 200, height: 50))
        viewArea.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        viewArea.layer.cornerRadius = 10
        
        //create label
        wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.blackColor()
        wait.hidesWhenStopped = true
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "reloading..."
        
        //add acctivity indicator and label to same view
        viewArea.addSubview(wait)
        viewArea.addSubview(text)
        
        //add to main view
        self.view.addSubview(viewArea)
        wait.startAnimating()
        
        
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // here code perfomed with delay
            self.tableView.reloadData()
            self.wait.stopAnimating()
            viewArea.removeFromSuperview()
        })
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecConvenience.sharedInstance().recipeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("recImage")! as UITableViewCell
        let recipeObj = RecConvenience.sharedInstance().recipeList[indexPath.row]
        
        dispatch_async(dispatch_get_main_queue(), {
            cell.imageView?.image = UIImage(data: recipeObj.image!)
            cell.textLabel?.text = (RecConvenience.sharedInstance().recipeList[indexPath.row]).recipeName
        })
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let defaults = NSUserDefaults.standardUserDefaults()
        

        
        //delete from core data
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let mc = appDelegate.managedObjectContext
        mc.deleteObject(RecConvenience.sharedInstance().recipeList[indexPath.row] as NSManagedObject)
        do {
            try mc.save()
        }catch _ as NSError {
        
        }
        //delete frme array and table view
        RecConvenience.sharedInstance().recipeList.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        if RecConvenience.sharedInstance().recipeList.count == 0{
            defaults.setInteger(1, forKey: "isEmpty")
            let isEmty = defaults.integerForKey("isEmpty")
            print ("the empty value is \(isEmty)")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexlocator = indexPath.row
        let recipeObj = RecConvenience.sharedInstance().recipeList[indexPath.row]
        _ = recipeObj.ingdprep
        RecConvenience.sharedInstance().recipeName = recipeObj.recipeName!
        RecConvenience.sharedInstance().ingdprep = recipeObj.ingdprep!
        RecConvenience.sharedInstance().cooktime = recipeObj.cookTime!
        RecConvenience.sharedInstance().recipeSteps = recipeObj.instrct!
        RecConvenience.sharedInstance().recipeImage = UIImage(data: recipeObj.image!)
        performSegueWithIdentifier("detailview", sender: self)
     }
}

