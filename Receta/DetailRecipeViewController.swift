//
//  DetailRecipeViewController.swift
//  Recipes
//
//  Created by arianne on 2016-01-06.
//  Copyright © 2016 della. All rights reserved.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    @IBOutlet weak var recipelab: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTextView: UITextView!
    
    @IBOutlet weak var ingrtsLabel: UILabel!
    @IBOutlet weak var recipeCookTime: UILabel!
    @IBOutlet weak var shareRecipeLabel: UIBarButtonItem!
    var isInstrPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        view.layer.cornerRadius = 10
        recipelab.text = RecConvenience.sharedInstance().recipeName
        recipeTextView.text = RecConvenience.sharedInstance().ingdprep
        recipeCookTime.text = RecConvenience.sharedInstance().cooktime
        recipeImage.image = RecConvenience.sharedInstance().recipeImage
    }
    
    @IBAction func recipSteps(sender: AnyObject) {
        if isInstrPressed == false {
            ingrtsLabel.text = "Instructions"
            isInstrPressed = true
            recipeTextView.text = RecConvenience.sharedInstance().recipeSteps
        }
        else {
            ingrtsLabel.text = "Ingredients"
            isInstrPressed = false
            recipeTextView.text = RecConvenience.sharedInstance().ingdprep

        }
    }
    
    @IBAction func shareRecipe(sender: AnyObject) {
         shareRecipeLabel.enabled = false
        //get image back
        let capRecipe: UIImage = generateMemedImage()
        let image = capRecipe
        
        let activityViewController = UIActivityViewController( activityItems: [image], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(s: String?, completed: Bool, items: [AnyObject]?, err:NSError?) in
            if !completed {
                self.shareRecipeLabel.enabled = true
                //show navigation
                self.navigationController?.setNavigationBarHidden(self.navigationController?.navigationBarHidden == false, animated: true)
                //show toolbar
                self.navigationController?.setToolbarHidden(false, animated: true)
                print("cancelled")
                return
            }
            if completed {
                self.shareRecipeLabel.enabled = true
                //show navigation
                self.navigationController?.setNavigationBarHidden(self.navigationController?.navigationBarHidden == false, animated: true)
                //show toolbar
                self.navigationController?.setToolbarHidden(false, animated: true)
            }
        }
    }
    
    //generate image to share
    func generateMemedImage() -> UIImage
    {
        //hide navigation
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == true, animated: true)
        //hide toolbar
        navigationController?.setToolbarHidden(true, animated: true)
        
        //UIStatusBarAnimation.Fade
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show navigation
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        //show toolbar
        navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
