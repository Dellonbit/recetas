//
//  RecApi.swift
//  Receta
//
//  Created by arianne on 2015-11-23.
//  Copyright © 2015 della. All rights reserved.
//

import UIKit
import CoreData

//http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        var attributedString:NSAttributedString?
        
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        }catch{
            print(error)
        }
        self.init(attributedString!.string)
    }
}

extension RecConvenience {
   
    func ingredSearch(ingSrch: String, completion: (success: Bool, errormsg: String) -> Void){
        let url = NSURL(string: "http://api.campbellskitchen.com/brandservice.svc/api/search?ingredient=\(ingSrch)&format=json&app_id=2d0c5d38&app_key=0de04f411ad26133e21a2c4b2099d13b" )
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if (error != nil) { // Handle error...
                //print("request error")
                completion(success: false, errormsg: "No internet connection")
            }
            else{
                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                //    var jsonError: NSError? = nil
                let result =  (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )) as! NSDictionary
                //return result
                
                if let locations = result["recipes"] as? [[String:AnyObject]] {
                        for k in locations {
                            let rec = k as NSDictionary
                            let recname = rec["name"]
                            let descp  = rec ["description"]
                            let recId = rec["recipe_id"]
                            let reclink = rec["recipelink"]
                            if let url = NSURL(string: reclink as! String) {
                                if let data = NSData(contentsOfURL: url) {
                                    //print(rec["recipelink"])
                                    let rect = Recete(recName: recname as! String, recsDcrtp: descp as! String, recImage: data, recID: (recId?.stringValue)!)
                                    self.tempList.append(rect)
                                    //print (rect.recsDecrip)
                                }
                             }
                          }
                        
                        completion(success: true, errormsg: "No intrest")
                }
             }
        }
        
        task.resume()
    }

    
    func getRecipeDetail(recId: String, completion: (success: Bool, errormsg: String) -> Void){
        let url = NSURL(string: "http://api.campbellskitchen.com/brandservice.svc/api/recipe/\(recId)?format=json&app_id=2d0c5d38&app_key=0de04f411ad26133e21a2c4b2099d13b" )
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            if (error != nil) { // Handle error...
                //print("request error")
                completion(success: false, errormsg: "No internet connection")
            }
            else{
                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                //    var jsonError: NSError? = nil
                var imgData: NSData!
                var recInstr: String!
                var recPrep: String!
                var reIng: String!
                var reNam: String!
                
                let result =  (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )) as! NSDictionary
               
                // get all information about recipes here
                let rcp = result["results"] as! NSDictionary
                
                // get name
                if let reName = rcp["name"] {
                    reNam = reName as! String
                    //print (reImg)
                }
                
                // get image
                if let reImg = rcp["bigimg"] {
                    
                    if let url = NSURL(string: reImg as! String) {
                        if let data = NSData(contentsOfURL: url) {
                            imgData = data
                        }
                        else {
                              imgData = nil
                        }
                    }
                }
                
                // get instructions
                if let steps = rcp["steps"] as? [[String:AnyObject]] {
                    recInstr = ""
                    for stp in steps{
                        let oldstr = stp["TipText"] as? String
                        let decodedString = String(htmlEncodedString: oldstr!)
                        let clrstr = decodedString.stringByReplacingOccurrencesOfString(".", withString:"\n")
                        recInstr = recInstr + clrstr
                    
                    
                    }
                }
                
                //get ingredients
                if let ingredients = rcp["ingredients"] as? [[String:AnyObject]] {
                        reIng = ""
                        for ingd in ingredients{
                            var Ing = ingd["ingredient_name"] as! String
                            let decodedString = String(htmlEncodedString: Ing)
                            let parstr = decodedString.stringByReplacingOccurrencesOfString("||", withString:" or ")
                            Ing = parstr + "\n"
                            reIng = reIng + Ing
                        }
                }
                
                // get preptime
                if let glance = rcp["glance"]{
                    recPrep = glance["totaltime"] as! String
                //print (steps)
                }
                
                do {
            
                    let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    
                    let reObj = Recipe(recpName: reNam, recpCookTime: recPrep, pic: imgData, indPrep: reIng, inst: recInstr, context: managedContext)
                    RecConvenience.sharedInstance().recipeList.append(reObj)
                    try managedContext.save()
                    
                } catch let error as NSError {
                    completion(success: false, errormsg: "No kjjnkjintrest")
                    print("Could not fetch \(error), \(error.userInfo)")
                }
            
                //managedContext.save()
                print(reNam)
             completion(success: true, errormsg: "No intrest")
            }
        }
        
        task.resume()
    }
    
} // end of class VTapi
