//
//  AnimationViewController.swift
//  Receta
//
//  Created by arianne on 2016-01-16.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit
import CoreData

class AnimationViewController: UIViewController {
    
    var RecipeName: [String] = ["Egg Benedict", "Mushroom Risotto", " Full Breakfast", "Hamburger", "Ham and egg sandwich"]
    var cookTime: [String]  = [ "30 min", "30 min", "20 min", "30 min", "10 min"]
    var arrayData:NSArray!
    var newarraytt: NSArray!
    var steps: String!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var ing1 = ["2 fresh English muffins", "4 eggs", "4 rashers of back bacon", "2 egg yolks", "1 tbsp of lemon juice", "125 g of butter", "salt and pepper"]
    
    var ing2 = [ "1 tbsp dried porcini mushrooms", "2 tbsp olive oil", "1 onion, chopped", "2 garlic cloves", "350g/12oz arborio rice", "1.2 litres/2 pints hot vegetable stock", "salt and pepper", "25g/1oz butter"]
    
    var ing3 = ["2 sausages", "100 grams of mushrooms", "2 rashers of bacon", "2 eggs", "150 grams of baked beans, Vegetable oil"]
    
    var ing4 = ["400g of ground beef", "1/4 onion (minced)", "1 tbsp butter", "hamburger bun", "1 teaspoon dry mustard", "Salt and pepper" ]
    
    var ing5 = [ "1 unsliced loaf (1 pound) French bread", "4 tablespoons butter", "2 tablespoons mayonnaise", "8 thin slices deli ham", "1 large tomato, sliced", "1 small onion", "8 eggs", "8 slices cheddar cheese"]
    
    var instr1 = "To Make Hollandaise: Fill the bottom of a double boiler part-way with water. Make sure that water does not touch the top pan. Bring water to a gentle simmer. In the top of the double boiler, whisk together egg yolks, lemon juice, white pepper, Worcestershire sauce, and 1 tablespoon water. Add the melted butter to egg yolk mixture 1 or 2 tablespoons at a time while whisking yolks constantly. If hollandaise begins to get too thick, add a teaspoon or two of hot water. Continue whisking until all butter is incorporated. Whisk in salt, then remove from heat. Place a lid on pan to keep sauce warm. Preheat oven on broiler setting. To Poach Eggs: Fill a large saucepan with 3 inches of water. Bring water to a gentle simmer, then add vinegar. Carefully break eggs into simmering water, and allow to cook for 2 1/2 to 3 minutes. Yolks should still be soft in center. Remove eggs from water with a slotted spoon and set on a warm plate. While eggs are poaching, brown the bacon in a medium skillet over medium-high heat and toast the English muffins on a baking sheet under the broiler. Spread toasted muffins with softened butter, and top each one with a slice of bacon, followed by one poached egg. Place 2 muffins on each plate and drizzle with hollandaise sauce. Sprinkle with chopped chives and serve immediately."
    
    var instr2 = "In a saucepan, warm the broth over low heat. Warm 2 tablespoons olive oil in a large saucepan over medium-high heat. Stir in the mushrooms, and cook until soft, about 3 minutes. Remove mushrooms and their liquid, and set aside. Add 1 tablespoon olive oil to skillet, and stir in the shallots. Cook 1 minute. Add rice, stirring to coat with oil, about 2 minutes. When the rice has taken on a pale, golden color, pour in wine, stirring constantly until the wine is fully absorbed. Add 1/2 cup broth to the rice, and stir until the broth is absorbed. Continue adding broth 1/2 cup at a time, stirring continuously, until the liquid is absorbed and the rice is al dente, about 15 to 20 minutes. Remove from heat, and stir in mushrooms with their liquid, butter, chives, and parmesan. Season with salt and pepper to taste."
    
    var instr3 = "Preheat the grill to high. Set the oven to its lowest heat and pop 2 plates in it to keep warm. Put the sausages, mushrooms and tomatoes, scored-side up, on to a large grill pan and place under the grill, about 5cm from the heat. Cook for about 10 minutes, turning the sausages once or twice. Add the bacon and black pudding to the pan and grill for 5 minutes, turning halfway through cooking, until they are cooked and crispy. Put the baked beans in a saucepan and warm gently for 2 to 3 minutes, stirring occasionally. Place a non-stick saucepan over a low heat. Melt 1 knob of butter in the pan, add the eggs, season to taste and stir gently until just scrambled. Remove from the heat. Put the bread in the toaster, and arrange the sausages, mushrooms and tomatoes with the bacon, black pudding and beans on the warm plates. When the toast pops up, butter it, then put a slice on each plate and top with scrambled egg. Serve with HP sauce or tomato ketchup on the side, and a pot of tea."
    
    var instr4 = "Preheat an outdoor grill for high heat. In a medium bowl, mix together the ground beef, egg, and garlic. Mix in steak sauce until mixture is sticky feeling. Form into 3 or 4 balls, and flatten into patties. Grill for about 10 minutes, turning once, or to your desired degree of doneness. The internal temperature should be at 180 degrees F (82 degrees C) when taken with a meat thermometer. Serve on buns with the usual trimmings."
    
    var instr5 = "Preheat oven to 375°. Cut bread in half lengthwise; carefully hollow out top and bottom, leaving 1/2-in. shells (discard removed bread or save for another use). Spread 3 tablespoons butter and all of the mayonnaise inside bread shells. Line bottom bread shell with ham; top with tomato and onion. In a large skillet, melt remaining butter; add eggs. Cook over medium heat, stirring occasionally until edges are almost set. Spoon into bottom bread shell; top with cheese. Cover with bread top. Wrap in greased foil. Bake 15-20 minutes or until heated through. Cut into serving-size pieces."
    

    var recipeImages: [String] = ["egg_benedict.png", "mushroom_risotto.png", " full_breakfast.png", "hamburger.png", "ham_and_egg_sandwich.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        RecConvenience.sharedInstance().ingdprep = ""
        view.layer.masksToBounds = true
        view.layer.opaque = false
        
        
        coreDataInfor { (success, error) -> Void in
            if success {
                let seconds = 5.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    // here code perfomed with delay
                    self.performSegueWithIdentifier("toNavList", sender: self)
                })
            }
            else {
                let msg  = " Unable to loadview"
                self.showMsg(msg)
                }
        }
    }
    
    // hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func coreDataInfor(completion:(success:Bool, error: NSString) -> Void){
        var ingdrnts = [ing1, ing2, ing3, ing4, ing5]
        var instrxn = [instr1, instr2, instr3,instr4, instr5]
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        var locations  = [Recipe]()
        do {
            locations =
                try managedContext.executeFetchRequest(fetchRequest) as! [Recipe]
            if locations.count > 1  {
               //load array in listViewcontroller
               RecConvenience.sharedInstance().recipeList = locations
                completion(success: true, error: "no error")
            }
            else if defaults.integerForKey("isEmpty") == 1{
                RecConvenience.sharedInstance().recipeList.removeAll()
                completion(success: true, error: "no error")
            }
                
            else  {
                //load data into coredata as well as listViewController before segue
                print("inside agate")
                defaults.setInteger(0, forKey: "isEmpty")
                for item  in  0 ..<  RecipeName.count {
                    var arraystring = ""
                    if let _ = UIImage(named: recipeImages[item]) {
                        let myImageName =  recipeImages[item]
                        let pic =  UIImagePNGRepresentation( UIImage(named: myImageName)!)

                         arraystring = ingdrnts[item].joinWithSeparator("\n")
                        let savedRecipe = Recipe(recpName: RecipeName[item], recpCookTime: cookTime[item], pic: pic!, indPrep: arraystring, inst: instrxn[item].stringByReplacingOccurrencesOfString(".", withString:"\n"), context: managedContext)
                        //emptystring
                        arraystring = ""
                        RecConvenience.sharedInstance().recipeList.append(savedRecipe)
                        try managedContext.save()
                     }
                    print(RecConvenience.sharedInstance().recipeList)
                }
                completion(success: true, error: "no error")
            }
        } catch let error as NSError {
            completion(success: false, error: "error" )
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func showMsg(msg:String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
