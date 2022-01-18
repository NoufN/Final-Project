//
//  ShowProfileUsers.swift
//  finalProject
//
//  Created by nouf on 06/01/2022.
//

import UIKit
import Firebase


class ShowProfileUsers: UIViewController {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var Bio: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var viewSub: UIView!
    let db = Firestore.firestore()
var userEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSub.layer.cornerRadius = 10
        viewSub.layer.cornerRadius = 20
        viewSub.layer.borderWidth = 0.1
        viewSub.layer.shadowColor = UIColor.black.cgColor
        viewSub.layer.shadowOffset = CGSize(width: 0, height: 5)
        viewSub.layer.shadowRadius = 5
        viewSub.layer.shadowOpacity =  0.50
        viewSub.layer.masksToBounds = false
     getUser(Email: userEmail)
        
        
        
    }
    
    func getUser(Email : String){
    
        db.collection("Users").whereField("emailUser", isEqualTo: Email).getDocuments { querySnapshot, error in
        
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
         
            for document in querySnapshot!.documents {
                let data = document.data()
                
        
                self.nameUser.text = data["userName"] as! String
                self.JobTitle.text = data["JobTitle"] as? String ?? ""
                self.Bio.text = data["Bio"] as? String ?? ""
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
             self.imageUser.image = UIImage(data: data!)!
            }
        }

    }

}
