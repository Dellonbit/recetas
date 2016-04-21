//
//  KitchenTableViewController.swift
//  Receta
//
//  Created by arianne on 2016-02-10.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit


class KitchenTableViewController: UITableViewController, UISearchBarDelegate {

    var searchController = UISearchController(searchResultsController: nil)
    var y :CGFloat = 0.0
    var x :CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.layer.cornerRadius = 10
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "type an ingredient to search..."
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.allowsMultipleSelection = true
        searchController.searchBar.delegate = self
        
        //activity indicator params
        let width: CGFloat = 200.0
        let height: CGFloat = 50.0
        x = self.view.frame.width/2.0 - width/2.0
        y = self.view.frame.height/2.0 - height/2.0
    }
   
    // http://stackoverflow.com/questions/32675001/uisearchcontroller-warning-attempting-to-load-the-view-of-a-view-controller
    deinit {
        self.searchController.loadViewIfNeeded()    // iOS 9
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
    
        dispatch_async(dispatch_get_main_queue(), {
             self.dismissViewControllerAnimated(true, completion: nil)
        })
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //zero array first
        RecConvenience.sharedInstance().tempList.removeAll()
        tableView.reloadData()
        var wait: UIActivityIndicatorView!
        
        //create uiview
        let viewArea = UIView(frame: CGRect(x: x, y: y, width: 200, height: 50))
        viewArea.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        viewArea.layer.cornerRadius = 10
        
        //create label
        wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.blackColor()
        wait.hidesWhenStopped = true
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "Downloading..."
        
        //add acctivity indicator and lable to same view
        viewArea.addSubview(wait)
        viewArea.addSubview(text)
        
        //add to main view
        self.view.addSubview(viewArea)
        wait.startAnimating()
        if Reachability.isConnectedToNetwork() == true {
        
                dispatch_async(dispatch_get_main_queue(), {
                    print("yippieeeeeee")
                    let indsearch = self.searchController.searchBar.text
                    let parstr = indsearch!.stringByReplacingOccurrencesOfString(" ", withString:"+")
                    
                    print(indsearch)
                    RecConvenience.sharedInstance().ingredSearch((parstr.lowercaseString), completion: { (success, errormsg) -> Void in
                            if success {
                                
                                if RecConvenience.sharedInstance().tempList.count == 0 {
                                    dispatch_async(dispatch_get_main_queue(), {
                                   let msg = "Sorry no recipes with \(indsearch!) found!"
                                   self.showMsg(msg, title: "")
                                    wait.stopAnimating()
                                    viewArea.removeFromSuperview()
                                    })
                                }
                                else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        wait.stopAnimating()
                                        viewArea.removeFromSuperview()
                                        self.tableView.reloadData()
                                    })
                                }
                            }
                                
                            else {
                                
                            }
                      })
                 })
        
        }else {
            wait.stopAnimating()
            viewArea.removeFromSuperview()
            let msg = "Internet connection FAILED"
            showMsg(msg, title: "")
        }

    }
    
    // update infor here
    @IBAction func updateRecp(sender: AnyObject) {        
        var wait: UIActivityIndicatorView!
        
        ///create uiview
        let viewArea = UIView(frame: CGRect(x: x, y: y, width: 200, height: 50))
        viewArea.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        viewArea.layer.cornerRadius = 10
        
        //create label
        wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.blackColor()
        wait.hidesWhenStopped = true
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "Updating..."
        
        //add acctivity indicator and label to same view
        viewArea.addSubview(wait)
        viewArea.addSubview(text)
        
        //add to main view
        self.view.addSubview(viewArea)
        wait.startAnimating()
        
        if Reachability.isConnectedToNetwork() == true {
            if let indexpaths = tableView.indexPathsForSelectedRows{
                var col = 0
                for item  in indexpaths {
                    let robj =  RecConvenience.sharedInstance().tempList[item.row]
                    if let _ = RecConvenience.sharedInstance().recipeList.indexOf({$0.recipeName == robj.recipeName}){
                        col++
                        wait.stopAnimating()
                        viewArea.removeFromSuperview()
                        print ("collision here \(indexpaths.count)")
                        if indexpaths.count == col {
                           let msg = "The recipe is already saved "
                           showMsg(msg, title: "Alert!")
                        }
                    }
                    else {
                        RecConvenience.sharedInstance().getRecipeDetail(robj.recipeId, completion: { (success, errormsg) -> Void in
                            if success {
                                dispatch_async(dispatch_get_main_queue(), {
                                    wait.stopAnimating()
                                    viewArea.removeFromSuperview()
                                    
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                })
                            }
                            else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    wait.stopAnimating()
                                    viewArea.removeFromSuperview()
                                    //self.tableView.reloadData()
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                })
                            }
                        })
                        
                     }
               print(item.row)
                }
            }
            
           else {
                dispatch_async(dispatch_get_main_queue(), {
                    let msg =  "No recipes selected"
                    self.showMsg(msg, title: "")
                    wait.stopAnimating()
                    viewArea.removeFromSuperview()
                    self.tableView.reloadData()
                })
            }
        }
        else {
            wait.stopAnimating()
            viewArea.removeFromSuperview()
            let msg = "Internet connection FAILED"
            showMsg(msg, title: "")
        
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  RecConvenience.sharedInstance().tempList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("kitchenCell", forIndexPath: indexPath)
        //as! KitchenTableViewCell
        if RecConvenience.sharedInstance().tempList.count > 0 {
           let recobj = RecConvenience.sharedInstance().tempList[indexPath.row]
         
         cell.accessoryType = UITableViewCellAccessoryType.DetailButton
         cell.textLabel?.text = recobj.recipeName
         cell.imageView?.image = UIImage(data: recobj.recipeImage)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            //print("the accessory button tapped is on row \(indexPath.row)")
            let recetobj = RecConvenience.sharedInstance().tempList[indexPath.row]
            let decodedString = String(htmlEncodedString: recetobj.recsDecrip)
            
            showMsg(decodedString, title: recetobj.recipeName)
    }
    
    func showMsg(msg:String, title:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
