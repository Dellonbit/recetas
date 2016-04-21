//
//  Recipe.swift
//  Receta
//
//  Created by arianne on 2016-02-17.
//  Copyright © 2016 della. All rights reserved.
//

import Foundation
import CoreData


class Recipe: NSManagedObject {
    
    @NSManaged var cookTime: String?
    @NSManaged var ingdprep: String?
    @NSManaged var recipeName: String?
    @NSManaged var image: NSData?
    @NSManaged var instrct: String?
    
    // Insert code here to add functionality to your managed object subclass
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(recpName:String, recpCookTime:String, pic:NSData, indPrep:String, inst: String, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Recipe", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        //insert core data
        cookTime = recpCookTime
        ingdprep = indPrep
        image = pic
        recipeName = recpName
        instrct = inst
    }
// Insert code here to add functionality to your managed object subclass

}
