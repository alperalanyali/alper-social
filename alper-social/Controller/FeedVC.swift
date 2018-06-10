//
//  FeedVC.swift
//  alper-social
//
//  Created by Alper on 10.06.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: key_uid)
        print("APO: ID removed from Keychain")
         try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
}
