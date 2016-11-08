//
//  ViewController.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/6/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
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
    @IBAction func removeProgress(_ sender: Any) {
        let controller = UIAlertController()
        controller.title = ""
        controller.message = "Delete Meme?"
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { _ in
            self.imageView.image = nil
            self.setVisibilityOfFields()
        }
        let dismiss = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)

        controller.addAction(YesAction)
        controller.addAction(dismiss)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (s, ok, items, error) in self.save() }
    }
    
    func setVisibilityOfFields(){
        if imageView.image == nil{
            shareButton.isEnabled = false
            emptyImageView.isHidden = false
            cancelButton.isEnabled = false
            for textfield in textfieldsArray{
                textfield.text = textfield.accessibilityHint
                textfield.isHidden = true
            }
        }else{
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
            emptyImageView.isHidden = true
            for textfield in textfieldsArray{
                textfield.isHidden = false
            }
        }
    }
    
    //Class Functions
    func save(){
        _ = Meme(topText: topTextView.text!, bottomText: bottomTextView.text!, image: imageView.image!, memedImage: generateMemedImage())
    }

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
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
    
    //Text Function
    private func setTextViewAttributes(){
        let myAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
            ] as [String : Any]
        
        
        //sets properties for each textfield in the array
        for textField in textfieldsArray {
            textField.delegate = memeTextDelegate
            textField.defaultTextAttributes = myAttributes
            textField.text = textField.accessibilityHint
            textField.textAlignment = NSTextAlignment.center
        }
    }

}

