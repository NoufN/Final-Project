//
//  DetailsProjectsVC.swift
//  finalProject
//
//  Created by nouf on 04/01/2022.
//

import UIKit
import Firebase

class DetailsProjectsVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    // project post
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var titleProject: UILabel!
    @IBOutlet weak var detailsProject: UILabel!
    @IBOutlet weak var specializayion: UILabel!
    @IBOutlet weak var connectionTool:  UILabel!
    @IBOutlet weak var Deadline: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    var projects : Projects? = nil
    
    //  comment
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var comment: UITextField!
    var comments = [Comment]()
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameUser.text = projects?.nameUser
        titleProject.text = projects?.nameProject
        detailsProject.text = projects?.detailsProject
        specializayion.text = projects?.specializayion
        connectionTool.text = projects?.ConnectionTool
        Deadline.text =  projects?.Deadline
        
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
    }
    
    //    func  loadProject(){
    //
    //        db.collection("Projects").getDocuments { [self] (querySnapshot, error) in
    //
    //            if let err = error {
    //                print("Error getting documents: \(err.localizedDescription)")
    //            } else {
    //                for document in querySnapshot!.documents {
    //                    let data = document.data()
    //                    self.nameUser.text = data["nameUser"] as? String ?? ""
    ////                    imageProfile.text
    //                    self.titleProject.text = data["Title"] as? String ?? ""
    //                    self.detailsProject.text = data["Details"] as? String ?? ""
    //                    self.specializayion.text = data["specializayion"] as? String ?? ""
    //                    self.connectionTool.text = data["connectionTool"] as? String ?? ""
    //                    self.Deadline.text =  data["Deadline"] as? String ?? ""
    //                    let date = data["DateCreated"] as? String ?? ""
    //                    self.dateCreated.text =  stringToDate(Date: date)
    //
    //
    //                }
    //
    //            }
    //        }
    //    }
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.isEmpty {
            return  0
            
        } else {
               
            return  comments.count
            
            }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.nameUser.text = comments[indexPath.row].name
        cell.comment.text = comments[indexPath.row].comment
        //        cell.imageUser
        
        cell.backgroundColor = .gray
        
        return cell
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        selected = projects[indexPath.row]
    //
    //        performSegue(withIdentifier: "show", sender: nil)
    //    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "show" {
    //            let nextVC = segue.destination as! DetailsProjectsVC
    //            nextVC.projects = selected
    //
    //
    //        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
}
