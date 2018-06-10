//
//  ViewController.swift
//  alper-social
//
//  Created by Alper on 7.06.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var pwdField: CustomField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        pwdField.delegate = self
    }

 
    
    // MARK: Buttons' Action
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("APO: Unable to authenticate with Facebook. :(")
            } else if result?.isCancelled == true {
                print("APO: User cancelled facebook authentication. :(")
            } else {
                print("APO: Successfully Authentication with Facebook :) ")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
 
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                if error == nil {
                    print("APO: Email User authenticated with Firebase :)")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("APO: Unable to authenticate with Firebase using Email :(")
                        } else {
                            print("APO: Successfully authenticated with Firebase using Email :)")
                        }
                    })
                }
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (resutl, error) in
            if error != nil {
                print("APO: Unable to authenticate with Firebase :(")
            } else {
                print("APO: Successfully authenticated with Firebase :)")
            }
        }
    }
    
    // MARK: TextField Function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
}

