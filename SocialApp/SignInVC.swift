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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

