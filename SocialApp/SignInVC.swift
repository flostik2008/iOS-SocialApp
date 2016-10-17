//
//  ViewController.swift
//  SocialApp
//
//  Created by Evgeny Vlasov on 10/9/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    override func viewDidAppear(_ animated: Bool) {
   
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Zhenya: ID found in keychain")
            
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
        
        
// Staff, to dismiss the keyboard:
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
//        pwdField.delegate = self
//        emailField.delegate = self
    }

//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        
//        
//    }
    

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Zhenya: Цукерман не может залогиниться \(error)" )
            } else if result?.isCancelled == true {
                print("Zhenya: User canceled FB authentication")
            } else {
                print("Zhenya: Successfully athenticated with FB")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
            self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("Zhenya: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Zhenya: Successfully auhenticated with Firebase.")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Zhenya: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    
                    // FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd) { (user, error) in
                        
                        
                        print ("Zhenya: Here it is: \(email) \(pwd)")
                            
                        if error != nil {
                            print("Zhenya: Unable to authenticate with Firbase using email")
                            print("Zhenya: \(error.debugDescription)")
                            
                        } else {
                            print("Zhenya: Successfully authenticated with Firbase")
                            if let user = user {
                            let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Zhenya: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        emailField.resignFirstResponder()
//        pwdField.resignFirstResponder()
//        return true
//    }
    
}

