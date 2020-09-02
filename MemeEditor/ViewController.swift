//
//  ViewController.swift
//  MemeEditor
//
//  Created by Mrunalini Gaddam on 8/10/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    // Variable will be used to check if the selected textfield is the bottom one
    var activeTextField: UITextField?
    
    //TO DISABLE CAMERA BUTTON IF CAM IS NOT AVAILABLE ON THE DEVICE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyBoardNotifications()
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyBoardNotifications()
    }
    override func viewDidLoad() {
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
          //setting text properties form dictionary
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        //text alignemnet to center
        self.topTextField.textAlignment = .center
        self.bottomTextField.textAlignment = .center
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //PICK IMAGE VIA CAMERA
    @IBAction func pickImageViaCamera(_ sender: Any) {
    chooseImageFromCameraOrPhoto(source: .camera)
   }
    
   //PICK IMAGE VIA LIBRARAY
   @IBAction func pickImageViaLibrary(_ sender: Any) {
    chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    //Share Via share button
    @IBAction func shareAnImage(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    //Cancel to share MEME
    @IBAction func doneToShareMeme(_ sender: Any) {
       // leaveMemeInBetween()
        self.dismiss(animated: true, completion: nil)
    }
    //To clear texts up on touch
    @IBAction func topTextField(_ sender: Any) {
        textFieldDidBeginEditing(topTextField)
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        textFieldDidBeginEditing(bottomTextField)
    }
    //COMMON METHOD TO SHARE VIA BOTH
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    //CONTROLS ON IMAGE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            
        }
        else if let editedImage = info[.editedImage] as? UIImage {
            imagePickerView.image = editedImage
        }
           shareButton.isEnabled = true
        print("share button action is active")
        dismiss(animated: true, completion: nil)
    
    }
    //IF Image picking is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       dismiss(animated: true, completion: nil)
    }
    //To clear text in text fields when user starts editing
    func textFieldDidBeginEditing(_ textField: UITextField){
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM"){
            textField.text = " "
        }
    }
    //to dismiss key board when user clicks return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
         textField.resignFirstResponder()
        return true
    }
    //Text in text field specifications
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.0
    ]
    // Variables that will hold data meme data from previous controller
    var sentTopText: String?
    var sentBottomText: String?
    var sentImage: UIImage?
    
    //Key board settings
    @objc func keyboardWillShow(_ notification:Notification){
        view.frame.origin.y -=  getKeyboardHeight(notification)
    }
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        // Create and save the meme
        let meme = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        originalImage:imagePickerView.image!,
                        memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        print(appDelegate.memes.count)
        
    }

    //Created final MEME
    func generateMemedImage() -> UIImage {
        //Hide tab and nav bars
        self.navigationController?.navigationBar.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true;
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show tab and nav bars
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = false;

        return memedImage
    }
    //to adapt user behaviour as discard in between
    func leaveMemeInBetween(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        //cant we make a recursive call?if yes,how!!
        initialState()
    }
   
    func initialState(){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
    }
}
