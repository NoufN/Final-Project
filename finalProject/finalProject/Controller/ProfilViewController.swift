//
//  ProfilViewController.swift
//  finalProject
//
//  Created by nouf on 31/12/2021.
//

import UIKit
import Firebase

class ProfilViewController: UIViewController {
 
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var Bio: UILabel!
    @IBOutlet weak var website: UILabel!
    
    let db = Firestore.firestore()
    var user = [User]()
    let email = Auth.auth().currentUser?.email
    var userSelected : User?
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    @IBAction func signOut(_ sender: Any) {
    
     do {
         try  Auth.auth().signOut()
         
         dismiss(animated: true, completion: nil)
     } catch  {
         print (error.localizedDescription)
     }
        
    }
    
   

 

    func loadData(){

            db.collection("Users").whereField( "emailUser", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
            
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
            self.user.removeAll()
            for document in querySnapshot!.documents {
                let data = document.data()
                
                self.nameUser.text = data["userName"] as! String
                self.JobTitle.text = data["JobTitle"] as? String ?? ""
                self.Bio.text = data["Bio"] as? String  ?? ""
                self.website.text = data["website"] as? String ?? ""
              
            }
        
            
        }
        
    }
    }

    
    
}
