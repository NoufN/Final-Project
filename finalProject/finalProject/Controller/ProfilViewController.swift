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
    
    @IBOutlet weak var subview: UIView!
    let db = Firestore.firestore()
    var user = [User]()
    let email = Auth.auth().currentUser?.email
    var userSelected : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        subview.layer.cornerRadius = 10
        subview.layer.cornerRadius = 20
        subview.layer.borderWidth = 0.1
        subview.layer.shadowColor = UIColor.black.cgColor
        subview.layer.shadowOffset = CGSize(width: 0, height: 5)
        subview.layer.shadowRadius = 5
        subview.layer.shadowOpacity =  0.50
        subview.layer.masksToBounds = false
        
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    
    
    func loadData(){
        
        db.collection("Users").whereField( "emailUser", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                self.user.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    self.nameUser.text = data["userName"] as? String
                    self.JobTitle.text = data["JobTitle"] as? String ?? ""
                    self.Bio.text = data["Bio"] as? String  ?? ""
                    self.website.text = data["website"] as? String ?? ""
                    let name = data["image"] as? String ?? ""
                    self.getImage(imgStr: name)
                    
                }
                
                
            }
            
        }
    }
    
    
    func getImage(imgStr: String )  {
        
        let url = "gs://finalproject-46146.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize:  1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
                
                
                self.imageProfile.image = UIImage(data: data!)!
            }
        }
        
    }
    
}
