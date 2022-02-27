//
//  AuthService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withUsername username: String , Email email: String , andPassword password: String , userCreationCompleat: @escaping (_ status: Bool , _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationCompleat(false, error)
                return
            }
            let userData = ["provider" : user.providerID,
                            "username" : username,
                            "email" : user.email ]
            DataService.instance.updateUserData(uid: user.uid, userData: userData as Dictionary<String, Any> )
            userCreationCompleat(true , nil)
        }
    }
    
    func loginUser(withEmail email: String , andPassword password: String , loginCompleat: @escaping (_ status: Bool , _ error: Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginCompleat(false, error)
                return
            }
            loginCompleat(true, nil)
            
        }
    }
    
    
    func resetPassword(withEmail email: String ,completion: @escaping (_ status: Bool , _ error: Error?) -> ()) {
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if error != nil {
                completion(false, error)
                return
            }
            completion(true, nil)
        })
        
    }
}
