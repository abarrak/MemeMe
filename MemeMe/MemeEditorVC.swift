//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Abdullah on 10/12/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memeModel: Meme?
    
    // Mark: VC Life Cycle and setup.
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activateCameraButtonIfAvailable()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsAppearance()
        populateMeme()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupTextFieldsAppearance() {
        imagePickerView.userInteractionEnabled = true
        stylizeTextField(topMemeText)
        stylizeTextField(bottomMemeText)
    }
    
    
    // Mark: UI interaction logic.
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let current: String = textField.text!.uppercaseString

        if current == "TOP" || current == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        launchPicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject){
        launchPicker(UIImagePickerControllerSourceType.Camera)
    }
    
    func launchPicker(type: UIImagePickerControllerSourceType) {
        // init image picker.
        let pickerController = UIImagePickerController()
        
        // handle responding to its messages.
        pickerController.delegate = self
        
        // set source type of media, and present controller.
        pickerController.sourceType = type
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get original image if any.
        let image: AnyObject? = info["UIImagePickerControllerOriginalImage"]
        
        if let m = image as? UIImage {
            imagePickerView.image = m
            activateShareButton()
            picker.dismissViewControllerAnimated(true, completion: nil)
        } else {
            alertMessage("Error", message: "Sorry, Image Selection Failed.")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // Mark: Resolve Keyboard/UI issue.
    
    func subscribeToKeyboardNotifications() {
        // FIXME: update to swift 3.0 syntax when upgrading Xcode.
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification,
            object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        // TODO: Use scrollView, or other more robust mechanism.
        // Helpful -> http://stackoverflow.com/q/28813339
        
        if bottomMemeText.editing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // Mark: Handling Meme modeling.
    
    func save() {
        // Build single instance of meme model.
        let memeImage = generateMemedImage()
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!,
            originalImage: imagePickerView.image!, memedImage: memeImage, sentDate: NSDate())
        
        // store in shared model.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        // friendly notify user.
        // alertMessage("Sent", message: "Meme has been sent successfully.")
    }
    
    
    // Mark: Share functionality.
    
    @IBAction func share() {
        let meme = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (type, completed, returnedItems, error) -> Void in
                if completed {
                    self.save()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // Mark: Existing memes fillling for editing capability.
    
    func populateMeme() {
        if let m = memeModel {
            topMemeText.text = m.topText
            bottomMemeText.text = m.bottomText
            imagePickerView.image = m.originalImage

            activateShareButton()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark: Helpers.
    
    func stylizeTextField(textField: UITextField) {
        // Some styling.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5.0,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        
        // Position in the center.
        textField.textAlignment = NSTextAlignment.Center
        
        // Make background transparent.
        textField.backgroundColor = UIColor.clearColor()
        
        // It's a child of a UIImageView.
        imagePickerView.addSubview(textField)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) {
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func activateCameraButtonIfAvailable() {
        let isCam = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraPickerButton.enabled = isCam
    }
    
    func activateShareButton() {
        shareButton.enabled = true
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        toggleViewBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toggleViewBars(hidden: false)
        
        return memedImage
    }
    
    func toggleViewBars(hidden hidden: Bool) {
        navbar.hidden = hidden
        toolbar.hidden = hidden
    }
}
