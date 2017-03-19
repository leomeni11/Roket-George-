//
//  LoginTableViewController.swift
//  Roket(George)
//
//  Created by george chin fu hou on 18/03/2017.
//  Copyright © 2017 George Chin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class LoginViewController: UITableViewController {
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!{
        didSet {
            loginButton.addTarget(self, action: #selector(loginPage), for: .touchUpInside)
        }
    }
    @IBAction func userSignUpButton(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {return}
        
        
        
        navigationController?.pushViewController(controller, animated: true)
    }
   


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    /// Login Function
    func loginPage () {
        
        FIRAuth.auth()?.signIn(withEmail: userTextField.text!, password: passTextField.text!, completion: { (user,error) in
            
            if error != nil {
                
                print(error! as NSError)
                self.showErrorAlert(errorMessage: "Email/Password Incorrect")
                return
            }
            
            guard let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileTableViewController") as?  ProfileTableViewController else { return }
            self.navigationController? .pushViewController(controller, animated: true)
            
        })
    
        }
    
    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
    }
    
}




