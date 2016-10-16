//
//  ViewController.swift
//  MemeMe
//
//  Created by Abdullah on 10/12/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    

    // Mark: VC Life Cycle and setup.
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activateCameraButtonIfAvailable()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldsAppearance()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupTextFieldsAppearance() {
        // Add some styleing.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5.0,
        ]

        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        // Position in the center.
        topMemeText.textAlignment = NSTextAlignment.Center
        bottomMemeText.textAlignment = NSTextAlignment.Center

        // Make background transparent.
        topMemeText.backgroundColor = UIColor.clearColor()
        bottomMemeText.backgroundColor = UIColor.clearColor()
        
        // They're childern of a UIImageView.
        imagePickerView.userInteractionEnabled = true
        imagePickerView.addSubview(topMemeText)
        imagePickerView.addSubview(bottomMemeText)
        
        topMemeText.delegate = self
        bottomMemeText.delegate = self
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
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get original image if any.
        let image: AnyObject? = info["UIImagePickerControllerOriginalImage"]
        
        if let m = image as? UIImage {
            imagePickerView.image = m
            self.dismissViewControllerAnimated(true, completion: nil)
            activateSaveAndShareButtons()
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
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // Mark: Handling Meme modeling.
    
    @IBAction func save() {
        let memeImage = generateMemedImage()
        let meme = Meme(topText: topMemeText.text!, bottomText: bottomMemeText.text!,
                        originalImage: imagePickerView.image!, memedImage: memeImage)
        print(meme)
        alertMessage("Saved", message: "Meme has been saved successfully")
        
        // Next will be collections and presistance.
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toggleViewBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toggleViewBars(hidden: false)

        return memedImage
    }
    
    func toggleViewBars(hidden hidden: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        self.toolbar.hidden = hidden
    }
    
    
    // Mark: Share functionality.
    
    @IBAction func share() {
        let meme = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)

        activityController.completionWithItemsHandler = {
            (type, completed, returnedItems, error) -> Void in
                if completed {
                    self.save()
                }
        }
        
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    
    // Mark: Helpers.
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) {
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func activateCameraButtonIfAvailable() {
        let isCam = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraPickerButton.enabled = isCam
    }
    
    func activateSaveAndShareButtons() {
        shareButton.enabled = true
        saveButton.enabled = true
    }
}
