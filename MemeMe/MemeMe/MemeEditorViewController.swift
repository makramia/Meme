//
//  ViewController.swift
//  MemeMe
//
//  Created by makramia on 14/11/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var sahreMemeButton: UIBarButtonItem!
    
    var memeTextAttributes: [NSAttributedString.Key : Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerView.contentMode = .scaleAspectFit
        
        memeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0]
        
        setupTextFiled(topTextField, defaultString: "TOP")
        setupTextFiled(bottomTextField, defaultString: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        
        // check if device does not have camera to disable camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        if(imagePickerView.image == nil){
            sahreMemeButton.isEnabled = false
        }else{
           sahreMemeButton.isEnabled = true
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupTextFiled(_ textField: UITextField, defaultString: String){
        textField.backgroundColor = UIColor.clear
        textField.text = defaultString
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
       
        if(bottomTextField.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0 //getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
     @IBAction func pickAnImage(_ sender:UIBarButtonItem) {
        switch(sender){
        case cameraButton:
            pickAnImageFrom(source: .camera)
        case albumButton:
            pickAnImageFrom(source: .photoLibrary)
        default:
            break
        }
    }
    
    func pickAnImageFrom(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imagePickerView.image = image
    }
    dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Text Field Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        hideNavbarAndToolbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hideNavbarAndToolbar(false)
        
        return memedImage
    }
    
    
    func save() {
        
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
      
        // TODO: in MemeMe 2.0 add to Meme tableview
        
        // Add meme to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        print(appDelegate.memes.count)
    }
    
    @IBAction func shareMeme(_ sender:Any){
    
    
    let memedImage = generateMemedImage()
    let items : [Any] = [memedImage]
    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
    //present(ac, animated: true)
        
        ac.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
       self.present(ac, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelMeme(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        sahreMemeButton.isEnabled = false
    }
    
    func hideNavbarAndToolbar(_ isHidden: Bool){
        topToolBar.isHidden = isHidden
        bottomToolBar.isHidden = isHidden
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
   
}

