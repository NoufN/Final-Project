//
//  ShowEditProject.swift
//  finalProject
//
//  Created by nouf on 12/01/2022.
//

import UIKit
import Firebase
class ShowEditProject: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
       // project post
       @IBOutlet weak var nameUser: UILabel!
       @IBOutlet weak var imageProfile: UIImageView!
       @IBOutlet weak var titleProject: UITextField!
       @IBOutlet weak var detailsProject: UITextView!
       @IBOutlet weak var specializayion: UILabel!
       @IBOutlet weak var connectionTool: UITextField!
       @IBOutlet weak var Deadline: UITextField!
       @IBOutlet weak var dateCreated: UILabel!
       var IdProject = ""
       var projects : Projects? = nil


       @IBOutlet weak var commentCollection: UICollectionView!

       var comments = [Comment]()
       var name = ""
       var profilImageName = ""
       var email = ""
       var emailUser = Auth.auth().currentUser?.email
       var selected = ""
       let db = Firestore.firestore()
       override func viewDidLoad() {
           super.viewDidLoad()
         
           getUser()

           nameUser.text =  projects?.nameUser
           titleProject.text = projects?.nameProject
           detailsProject.text = projects?.detailsProject
           specializayion.text = projects?.specializayion
           connectionTool.text = projects?.ConnectionTool
           Deadline.text =  projects?.Deadline
           let name = (projects?.image)!
           
   getImage(imgStr: name)
           
           dateCreated.text =  stringToDate(Date: projects!.DateCreated)
           
           IdProject = projects!.IdProject
           
           commentCollection.delegate = self
           commentCollection.dataSource = self
           loadComment()
      
       
       }
       
    
    
    
    
    @IBAction func deleteProject(_ sender: Any) {
//
     
        let alert = UIAlertController(title: "تنبية" , message: "هل تريد حذف المشروع ؟", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "نعم", style: .default) { action in
            
            self.db.collection("Projects").document(self.IdProject).delete() { err in
                               if let err = err {
                                   print("Error removing document: \(err.localizedDescription)")
                               } else {
                                   self.navigationController?.popViewController(animated: true)
                               }
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel , handler: nil ))
        present(alert, animated: true , completion: nil)
          
        
    }
 
    
    @IBAction func edit(_ sender: Any) {
        updateData()
    }
    
    
    
       func  loadComment(){

           
           db.collection("Projects").document(IdProject).collection("Comments").getDocuments { [self] (querySnapshot, error) in

               if let err = error {
                   print("Error getting documents: \(err.localizedDescription)")
               } else {
                   for document in querySnapshot!.documents {
                       let data = document.data()
                       comments.append(Comment(name:  data["userName"] as? String ?? "", comment: data["Comments"] as? String ?? "", image:    data["image"] as? String ?? "", email:data["emailUser" ] as? String ?? ""  ))
                 
                   }
                   DispatchQueue.main.async {
                       self.commentCollection.reloadData()
               }

               }
           }
       }
    func updateData() {
       
        self.db.collection("Projects").document(IdProject).updateData([
            
            "Title"  : titleProject.text!,
            "Details" :   detailsProject.text ,
            "Deadline" :  Deadline.text  ,
            "ConnectionTool" : connectionTool.text! ,
           
        ]) { err in
            if let err = err {
                print("Error updating document: \(err.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
       
       func getUser()  {
           if let emailUser = emailUser {
               db.collection("Users").document(emailUser).getDocument{ documentSnapshot, error in
                   if let error = error {
                       print("Error: ",error.localizedDescription)
                   }else {
                       
                       self.name  = documentSnapshot?.get("userName") as? String ?? "nil"
                       self.profilImageName = documentSnapshot?.get("image") as? String ?? "nil"
               
                   }
               }
               
               
               
           }
       }
          

    
       
       

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           selected = comments[indexPath.row].email
           performSegue(withIdentifier: "show", sender: nil)
       }
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "show" {
               let nextVC = segue.destination as! ShowProfileUsers
               nextVC.userEmail = selected
           
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if comments.isEmpty {
               return  0
               
           } else {
               
               return  comments.count
               
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
           cell.nameUser.text = comments[indexPath.row].name
           cell.comment.text = comments[indexPath.row].comment
           cell.comment.numberOfLines = 3
          let name = comments[indexPath.row].image
           let url = "gs://finalproject-46146.appspot.com/images/" + "\(name)"
           let Ref = Storage.storage().reference(forURL: url)
           Ref.getData(maxSize:  1024 * 1024) { data, error in
               if error != nil {
                   print("Error: Image could not download!")
               } else {
                   cell.imageUser.image = UIImage(data: data!)!
                   cell.imageUser.layer.borderWidth = 1
                   cell.imageUser.layer.masksToBounds = true
                   cell.imageUser.layer.borderColor = UIColor.black.cgColor
                   cell.imageUser.layer.cornerRadius =   self.imageProfile.frame.height/2
                   cell.imageUser.clipsToBounds = true
               }
               DispatchQueue.main.async {
                   self.commentCollection.reloadData()
           }
           }


           cell.layer.cornerRadius = 15
           cell.backgroundColor = .gray
           
           return cell
       }
       func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize{
           
           return CGSize(width:  (commentCollection.layer.bounds.width ) - 20 , height: (view.layer.bounds.height)/10)
           
       }
       
       func getImage(imgStr: String )  {

           let url = "gs://finalproject-46146.appspot.com/images/" + "\(imgStr)"
           let Ref = Storage.storage().reference(forURL: url)
           Ref.getData(maxSize:  1024 * 1024) { data, error in
               if error != nil {
                   print("Error: Image could not download!")
               } else {
                 

                   self.imageProfile.image = UIImage(data: data!)!
                   self.imageProfile.layer.borderWidth = 1
           self.imageProfile.layer.masksToBounds = true
          self.imageProfile.layer.borderColor = UIColor.black.cgColor
                   self.imageProfile.layer.cornerRadius =   self.imageProfile.frame.height/2
                   self.imageProfile.clipsToBounds = true
               }
           }

       }

}
