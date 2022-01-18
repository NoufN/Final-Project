//
//  SettingVC.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import UIKit
import Firebase

class SettingVC: UIViewController {
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func signOut(_ sender: Any) {
        let alert = UIAlertController(title: "تنبية" , message: "هل تريد تسجيل الخروج ؟", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "نعم", style: .default) { action in
            
            
            do {
                try  Auth.auth().signOut()
                
                self.dismiss(animated: true, completion: nil)
            } catch  {
                print (error.localizedDescription)
            }
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel , handler: nil ))
        present(alert, animated: true , completion: nil)
    }
    @IBAction func deletAccount(_ sender: Any) {
        let alert = UIAlertController(title: "تنبية" , message: "هل تريد حذف الحساب نهائي ؟", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "نعم", style: .default) { action in
            
            
            let user = Auth.auth().currentUser
            
            self.db.collection("Users").document((user?.email) as! String).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err.localizedDescription)")
                } else {
                
                    user?.delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            Auth.auth().currentUser?.delete()
                            
                        
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            
           
            
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel , handler: nil ))
        present(alert, animated: true , completion: nil)
    }
    
}
