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

class FeedVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionField: CustomField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: RoundImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captionField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
//            print(snapshot.value!)
            self.posts = []
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
    
    //MARK: Tableview functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThePost") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
              
            } else {
                    cell.configureCell(post: post)
                
            }
            return cell
        } else {
            return PostCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 365
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
            
        } else {
            print("APO: A valid image wasn't selected. :(")
        }
            imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker,animated: true, completion: nil)
        
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("APO: Caption must be entered")
            return
        }
        guard let img = addImage.image, imageSelected == true else {
            
            print("APO: An image must be selected")
            return
        }
        
         let data = UIImageJPEGRepresentation(img, 0.6)
            
            
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
        
      
        
       
        DataService.ds.REF_STORAGE_IMAGE.child(imgUid).putData(data!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("APO: Unable to upload image to Firebase Storage")
            } else {
                print("APO: Successfully uploaded image to Firebase")
                if let path = metadata?.path {
                    let url = "\(self.storageRef)/\(path)"
                    print("APO: URL: \(url)")
                    self.updateView(imgURL: url)
                }
               
            }
        }
    }
    
    let storageRef = Storage.storage().reference(forURL: "gs://alper-social-f84f7.appspot.com")

    func updateView(imgURL: String) {
        let post : Dictionary<String, AnyObject> = [
            "caption": self.captionField.text as AnyObject,
            "imageUrl": imgURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
//        tableView.reloadData()
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
