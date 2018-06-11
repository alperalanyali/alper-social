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

class FeedVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var captionField: CustomField!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captionField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
//            print(snapshot.value!)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("APO: SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print("APO: \(post.caption)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThePost") as! PostCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 365
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: key_uid)
        print("APO: ID removed from Keychain \(keychainResult)")
         try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
