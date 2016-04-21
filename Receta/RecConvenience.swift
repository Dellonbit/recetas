//
//  VTConvenience.swift
//  Virtual Tourist
//
//  Created by arianne on 2015-12-05.
//  Copyright © 2015 della. All rights reserved.
//

import UIKit
import MapKit

class RecConvenience: NSObject {

    var recipeList = [Recipe]()
    var tempList = [Recete]()
    var badgecount:Int = 0
    var cooktime:String = ""
    var ingdprep:String = ""
    var recipeImage:UIImage!
    var recipeName:String = ""
    var recipeSteps = ""
    
    // MARK: - Shared Instance: singleton class
    class func sharedInstance() -> RecConvenience {
        
        struct Singleton {
            static var sharedInstance = RecConvenience()
        }
        return Singleton.sharedInstance
    }

}
