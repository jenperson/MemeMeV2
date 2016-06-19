//
//  ViewController.swift
//  Meme Me
//
//  Created by Jennifer Person on 5/9/16
//  Copyright © 2016 udacity. All rights reserved.
//

import UIKit
import Foundation


class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Set up button names
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let TOP_DEFAULT_TEXT = "TEXT"
    let BOTTOM_DEFAULT_TEXT = "TEXT"
    
    var memedImage:UIImage!
    
    let memeTextDelegate = MemeTextFieldDelegate()
    
    var meme: Meme!
    var memes: [Meme]! {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // Sets attributes of the appearance of the text
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    enum TextFields {
        case topTextField
        case bottomTextField
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set default text of fields
        topTextField.text = TOP_DEFAULT_TEXT
        bottomTextField.text = BOTTOM_DEFAULT_TEXT
        
        // Set default text attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.delegate = memeTextDelegate
        self.bottomTextField.delegate = memeTextDelegate
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Modified from https://github.com/mrecachinas/MemeMeApp/blob/master/MemeMe/MemeEditorViewController.swift
        
        // If image picker has an image
        if let _ = imagePickerView.image {
            // Enable sharing
            shareButton.enabled = true
        } else {
            // Disable sharing until an image is visible
            shareButton.enabled = false
        }
        
        // Only enable camera button if a camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // Image Functions
    
    // Source: https://github.com/mrecachinas/MemeMeApp/blob/master/MemeMe/MemeEditorViewController.swift
    func pickImageFromSource(source:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let thisImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = thisImage
            imagePickerView.contentMode = .ScaleAspectFit
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
        
    // Modified from: https://github.com/mrecachinas/MemeMeApp/blob/master/MemeMe/MemeEditorViewController.swift
    @IBAction func shareAction(sender: UIBarButtonItem) {
        // Creates memed image when share is pressed
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // Log results to console
        activityViewController.completionWithItemsHandler = { (s: String?, ok: Bool, items: [AnyObject]?, err: NSError?) -> Void in
            if ok {
                self.self.save()
                NSLog("Successfully saved image.")
            } else if err != nil {
                NSLog("Error: \(err)")
            } else {
                NSLog("User clicked cancel")
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    // View works in all directions of iOS device but upside down
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.AllButUpsideDown]
    }
    
    
    //  Keyboard Functions
    
    // Source: https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558
    // Moves up frame if bottom text field is selected so it can be read over keyboard
    func keyboardWillShow(notification: NSNotification) -> Void{
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y = -getKeyboardHeight(notification);
        }
    }
    
    // Listens for keyboard to know when to move up frame
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Source: https://classroom.udacity.com/nanodegrees/nd003/parts/0031345406/modules/468495242375460/lessons/4798201455/concepts/38760686140923
    // Gets height of keyboard so frame can be moved up to read text
    func getKeyboardHeight(notification:NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // Moves frame back down once keyboard is no longer needed
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    // Stops listening to keyboard when no longer needed
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardDidShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardDidHideNotification, object:nil)
        
    }
    
    // Hide or unhide toolbars
    func hideToolBars(isHidden : Bool) {
        topToolBar.hidden = isHidden
        bottomToolBar.hidden = isHidden
    }

    // Meme Creation Functions
    
    // Meme is created
    func generateMemedImage() -> UIImage {
        
        // Hide toolbars so meme can be created
        hideToolBars(true)
        
        // Create meme
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars because meme has been created
        hideToolBars(false)
        
        return memedImage
    }
    
    // Save or cancel meme
    
    // Saves a copy of the meme
    func save () {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, pickerViewImage:imagePickerView.image!, memedImage:memedImage)

        
        // Add it to memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    
    // Clears out the meme to start over
    
    func cancel(){
        presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        cancel()
    }
}





