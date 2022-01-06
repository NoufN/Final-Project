//
//  LogeInVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class LogeInVC: UIViewController {
    
    @IBOutlet weak var emilUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    let db = Firestore.firestore()
    var taypUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()



    }
    
    
    @IBAction func signInAction(_ sender: Any){
        if emilUser.text != "" && passwordUser.text != "" {

            Auth.auth().signIn(withEmail: emilUser.text!, password: passwordUser.text!) { user, error in

                if let error = error {
                    print("Error: ",error.localizedDescription)
                    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }else{

                    self.db.collection("Users").whereField(  "emailUser", isEqualTo: self.emilUser.text!).addSnapshotListener{(querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err.localizedDescription)")
                        } else {
                            for document in querySnapshot!.documents {
                                let data = document.data()

                                self.taypUser = data["taypUser"] as! String
                             print( self.taypUser)
                            }
                        }
                        
                  if self.taypUser == "Client" {
                        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabBar")
                        as! ClientTabBar
                        tabBar.modalPresentationStyle = .fullScreen
                        self.present( tabBar, animated: true , completion: nil)
                        
                    } else if self.taypUser == "Developers"  {
                        
                        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "DeveloperTabBar")
                        as! DeveloperTabBar
                        tabBar.modalPresentationStyle = .fullScreen
                        self.present( tabBar, animated: true , completion: nil)
                    }
                    
                }
            }
        }
        } else {
            let alert = UIAlertController(title: "عذرًا", message:"يجب عليك ملىء كل الحقول المطلوبة", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "نعم", style: .default) { _ in })

            present(alert, animated: true, completion: nil)
        }

   
    
}
}

