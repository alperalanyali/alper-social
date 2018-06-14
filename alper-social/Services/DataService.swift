//
//  DataService.swift
//  alper-social
//
//  Created by Alper on 11.06.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


let DB_BASE = Database.database().reference()
  let STORAGE_BASE = Storage.storage().reference()


class DataService {
  
    static  let ds = DataService()
    
    
    //MARK: Data Encapsulation of DB References
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //MARK: Data Encapsulation of Storage References
    
    private var _REF_STORAGE_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: key_uid)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    
    var REF_STORAGE_IMAGE: StorageReference {
        return _REF_STORAGE_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
