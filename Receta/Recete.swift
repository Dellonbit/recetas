//
//  Recete.swift
//  Receta
//
//  Created by arianne on 2016-02-11.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit
class Recete {
    var  recipeName: String!
    var  recipeImage: NSData!
    var  recipeId: String!
    var  recsDecrip: String

    init (recName: String, recsDcrtp: String, recImage: NSData, recID: String) {
        recipeName = recName
        recipeImage = recImage
        recipeId = recID
        recsDecrip = recsDcrtp
    }
}
