/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController {
   
    var signupActive = true
  
    @IBOutlet weak var username: UITextField!
 
    @IBOutlet weak var password: UITextField!
  
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()  
    @IBOutlet weak var enterButton: UIButton!   
    @IBOutlet weak var registeredText: UILabel!  
    @IBOutlet weak var loginButton: UIButton!
    
   
    func displayAlert(title: String, message: String)
    {  
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)       
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)   
    }

    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == ""  || password.text == ""
        {
            displayAlert("Error in form", message: "Please enter a username and password")
        } 
        else
        {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later."
           
            if signupActive == true
            {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil
                {
                self.performSegueWithIdentifier("login", sender: self)
                //signup successful
                }
                else
                {
                 if let errorString = error!.userInfo["error"] as? String
                 {
                    errorMessage = errorString
                    
                    }
                    
                    self.displayAlert("Failed signup", message : errorMessage)
                }
            })
        
            }
            else
            {
            
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if user != nil
                {
                    self.performSegueWithIdentifier("login", sender: self)
                
                }
                else
                {
                    if let errorString = error!.userInfo["error"] as? String
                    {
                        errorMessage = errorString                       
                    }                   
                    self.displayAlert("Failed Login", message : errorMessage)      
                }            
            })         
            }
        }        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true
        {
        
        enterButton.setTitle("Login", forState: UIControlState.Normal)
            registeredText.text = "Not registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false      
        }    
        else
        {        
            enterButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true    
        }      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
    }    
    override func viewDidAppear(animated: Bool) {
       /* if PFUser.currentUser() != nil
        {
            //otomatik login olsun istiyorsan
           // self.performSegueWithIdentifier("login", sender: self)
        
        }
        */  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
