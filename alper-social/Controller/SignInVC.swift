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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("APO: Unable to authenticate with Facebook")
            } else if result?.isCancelled == true {
                print("APO: User cancelled facebook authentication")
            } else {
                print("APO: Successfully Authentication with Facebook :) ")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (resutl, error) in
            if error != nil {
                print("APO: Unable to authenticate with Firebase")
            } else {
                print("APO: Successfully authenticated with Firebase")
            }
        }
    }
}

