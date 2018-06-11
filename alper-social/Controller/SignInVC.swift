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
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: CustomField!
    @IBOutlet weak var pwdField: CustomField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        pwdField.delegate = self
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: key_uid){
            print("APO: ID found in Keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
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
                    if let user = user {
                        let userData = ["provider": user.user.providerID]
                        self.completeSignIn(id: (user.user.uid), userData: userData )
                    }
                 
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("APO: Unable to authenticate with Firebase using Email :(")
                        } else {
                            print("APO: Successfully authenticated with Firebase using Email :)")
                            if let user = user {
                                let userData = ["provider": user.user.providerID]
                                self.completeSignIn(id: (user.user.uid),userData: userData)
                            }
                            
                        }
                    })
                }
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil {
                print("APO: Unable to authenticate with Firebase :(")
            } else {
                print("APO: Successfully authenticated with Firebase :)")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.user.uid, userData: userData)
                }
                
            }
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>){
            DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
            let keychainResult = KeychainWrapper.standard.set(id, forKey: key_uid)
            print("APO: Data saved to Keychain \(keychainResult)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    // MARK: TextField Function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
}

