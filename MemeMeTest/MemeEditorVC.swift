//
//  ViewController.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/6/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextView: UITextField!
    @IBOutlet weak var bottomTextView: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var emptyImageView: UIStackView!

    var textfieldsArray: [UITextField] = []
    let memeTextDelegate = MemeTextFieldDelegate()
    
    
    //Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldsArray = [topTextView, bottomTextView]
        setTextViewAttributes()
        
        //Enables the emtpyView to be clickable and to open the image selection upon tap
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        emptyImageView.isUserInteractionEnabled = true
        emptyImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        setVisibilityOfFields()
        registerKeyboardNotifications()
    }
    
    //Opens ImagePicker from library when emptyView button is tapped
    func imageTapped(img: AnyObject){
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    //Action Functions
    @IBAction func pickImage(_ sender: Any){
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    /*
     * Cancel Button Action : Asks the user for reassurance to leave if 
     * they have began editing.
     */
    @IBAction func removeProgress(_ sender: Any) {
        //If the user has begun editing, ask if they are sure to exit.
        if imageView.image != nil{
            let controller = UIAlertController()
            controller.title = ""
            controller.message = "Exit Editor?"
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { _ in
                self.imageView.image = nil
                self.setVisibilityOfFields()
                self.returnToPreviousVC()
            }
            let dismiss = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
            controller.addAction(YesAction)
            controller.addAction(dismiss)
            present(controller, animated: true, completion: nil)
        }else{
            self.returnToPreviousVC()
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (s, ok, items, error) in self.save() }
    }
    
    //sets visibility rules for each field depending on the current state.
    func setVisibilityOfFields(){
        if imageView.image == nil{
            shareButton.isEnabled = false
            emptyImageView.isHidden = false
            clearTextFields()
            for textfield in textfieldsArray{
                textfield.isHidden = true
            }
        }else{
            shareButton.isEnabled = true
            emptyImageView.isHidden = true
            for textfield in textfieldsArray{
                textfield.isHidden = false
            }
        }
    }
    
    //dismisses Current view to return to table/collection views.
    func returnToPreviousVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //Class Functions
    func save(){
        let meme = Meme(topText: topTextView.text!, bottomText: bottomTextView.text!, image: imageView.image!, memedImage: generateMemedImage())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memesArray.append(meme)
    }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        clearTextFields()
        shareButton.isEnabled = true
    }
    
    //creates the final memed image with text & picture together
    func generateMemedImage() -> UIImage{
        configureBars(hidden: true)
        for textfield in textfieldsArray{
            textfield.endEditing(true)
        }
            // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        configureBars(hidden: false)
        return memedImage
    }
    
    func configureBars(hidden: Bool){
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }
    
    //Keyboard Functions
    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && bottomTextView.isEditing{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    private func clearTextFields(){
        for textfield in textfieldsArray{
            textfield.text = textfield.accessibilityHint
        }
    }
    
    //Text Function
    private func setTextViewAttributes(){
        let myAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
            ] as [String : Any]
        
        
        clearTextFields()
        //sets properties for each textfield in the array
        for textField in textfieldsArray {
            textField.delegate = memeTextDelegate
            textField.defaultTextAttributes = myAttributes
            textField.textAlignment = NSTextAlignment.center
        }
    }

}

