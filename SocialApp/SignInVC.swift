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

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
//        pwdField.delegate = self
//        emailField.delegate = self
    }

//    func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        
    }
    

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
            }
        })
    }
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Zhenya: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            print("Zhenya: Unable to authenticate with Firbase using email")
                        } else {
                            print("Zhenya: Successfully authenticated with Firbase")
                        }
                    })
                }
            })
        }
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        emailField.resignFirstResponder()
//        pwdField.resignFirstResponder()
//        return true
//    }
}

