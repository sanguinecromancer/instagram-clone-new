//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Zeynep Aykal on 17/05/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class PostImageViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    func displayAlert(title: String, message: String)
    {
        //function for displaying success alert when picture is uploaded
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    //activity indicator roll
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    
    
    
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        // view.addSubview(<#T##view: UIView##UIView#>)
        
        
        
        
    }
    
    
    
    
    
    
    @IBOutlet weak var message: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        var post = PFObject(className: "Post")
        
        post["message"] = message.text
        post["userId"] = PFUser.currentUser()!.objectId!
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        post["imageFile"] = imageFile
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if error == nil
            {
            self.imageToPost.image = UIImage(named: "placeholder.png")
            self.message.text = ""
                self.displayAlert("Image posted!", message: "Upload successful")
            }
            else
            {
                self.displayAlert("error", message: "upload has failed")

            
            }
            
            
            
        }
        
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
