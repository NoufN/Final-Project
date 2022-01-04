//
//  SettingVC.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import UIKit
import Firebase

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signOut(_ sender: Any) {
    
     do {
         try  Auth.auth().signOut()
         
         dismiss(animated: true, completion: nil)
     } catch  {
         print (error.localizedDescription)
     }
        
    }
    
    @IBAction func deletAccount(_ sender: Any) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              print(error.localizedDescription)
          } else {
              Auth.auth().currentUser?.delete()
          }
        }
    }
  
}
    

//do {
// try  Auth.auth().signOut()
//
// dismiss(animated: true, completion: nil)
//} catch  {
// print (error.localizedDescription)
//}
