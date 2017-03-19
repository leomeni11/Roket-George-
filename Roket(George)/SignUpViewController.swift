//
//  SignUpTableViewController.swift
//  Roket(George)
//
//  Created by george chin fu hou on 18/03/2017.
//  Copyright © 2017 George Chin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate ,UITextViewDelegate, UINavigationControllerDelegate {
   
    var dbRef : FIRDatabaseReference!
    var selectedImage : UIImage?
    

    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBAction func userVerifyButton(_ sender: UIButton) {
        createAccount()
    }

    
    @IBOutlet weak var selectPictureButton: UIButton!{
        didSet{
            
            selectPictureButton.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        }
        
    }
    func createAccount() {
        
        guard let email = userEmail.text,
        let password = userPass.text else {
            return

        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user,error) in
            
            if error != nil{
                
                self.showErrorAlert(errorMessage: " Email/Password Format Invalid")
                print (error! as NSError)
                return
                
            } else {
                let alertMessage = UIAlertController (title: "Message", message: "Successfully Register", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.handleUser()
                })
                alertMessage.addAction(okAction)
                
                self.present(alertMessage, animated: true, completion: nil)
                
            }
            //send infromation to database
            let ref = FIRDatabase.database().reference()
            let value = ["email": email ] as [String : Any]
            let uid = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(uid!).updateChildValues(value, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print("err")
                    return
                }
                self.uploadImage(image: self.userImage.image!)
            })
        })
    }
    
    
    func handleUser() {
        
        guard let controller = UIStoryboard(name: "AuthStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as?  LoginViewController
            else { return }
        self.present(controller, animated: true, completion: nil)
        //navigationController? .pushViewController(controller, animated: true)
    }
    
    var userStorage: FIRStorageReference!

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://roket-ad346.appspot.com")
        userStorage = storage.child("users")

    }

    func displayImagePicker(){
        
        let pickerViewController = UIImagePickerController ()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pickerViewController.sourceType = .photoLibrary
            
        }
        
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setProfileImage(image : image)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setProfileImage(image : UIImage) {
        userImage.image = image
    }
    
    func uploadImage(image: UIImage){
        
        // create the Data from UIImage
        guard let imageData = UIImageJPEGRepresentation(image, 0.0) else { return }
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let uid = FIRAuth.auth()?.currentUser?.uid
        let storageRef = FIRStorage.storage().reference()
        storageRef.child("folder").child("\(uid!).jpeg").put(imageData, metadata: metadata) { (meta, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                
                if let downloadURL = meta?.downloadURL() {
                    //got image url
                    self.dbRef.child("users").child(uid!).child("profileURL").setValue(downloadURL.absoluteString)
                }
                
                //    self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
        
    }
    
}
