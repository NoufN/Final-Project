//
//  HomeForClientVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class HomeForClientVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    var projects = [Projects]()
 
    

    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var project: UISegmentedControl!
    var selected : Projects? = nil
    var initialCenter = CGPoint()
    
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email

    
//   var projects = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllProjects()
        tableView.delegate = self
        tableView.dataSource = self
        addProjectButton.layer.cornerRadius = 0.5 * addProjectButton.bounds.size.width
        addProjectButton.clipsToBounds = true
      
    
 
    }
    override func viewWillAppear(_ animated: Bool) {
        loadAllProjects()
    }
//    @IBAction func indexChanged(sender: UISegmentedControl) {
//        switch project.selectedSegmentIndex
//        {
//        case 0:
//        projects = "Projects"
//
//        case 1:
//            projects  = "My Project "
//
//        default:
//            break;
//        }
//    }
   @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
       guard gestureRecognizer.view != nil else {return}
       let piece = gestureRecognizer.view!
       let translation = gestureRecognizer.translation(in: piece.superview)
       if gestureRecognizer.state == .began {
   
          self.initialCenter = piece.center
       }
     
       if gestureRecognizer.state != .cancelled {
          let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
          piece.center = newCenter
       }
       else {
          piece.center = initialCenter
       }

    }
    
    
    func  loadAllProjects(){
        projects.removeAll()
        db.collection("Projects").getDocuments { (querySnapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                self.projects.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
             
                    
                    self.projects.append(Projects(nameProject:data["Title"] as? String ?? "", detailsProject: data["Details"] as? String ?? "", Deadline: data["Deadline"] as? String ?? "" , ConnectionTool: data["connectionTool"] as? String ?? "", DateCreated: data["DateCreated"] as? String ?? "" , specializayion: data["specializayion"] as? String ?? ""))
        
                   
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    func loadData(){

            db.collection("Users").whereField( "emailUser", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
            
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
         
            for document in querySnapshot!.documents {
                let data = document.data()
                
//                self.nameUser.text = data["userName"] as! String
//                self.JobTitle.text = data["JobTitle"] as? String ?? ""
//                self.Bio.text = data["Bio"] as? String  ?? ""
//                self.website.text = data["website"] as? String ?? ""
              
            }
        
            
        }
        
    }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        
        cell.nameProject.text = projects[indexPath.row].nameProject
        cell.detailsProject.text = projects[indexPath.row].detailsProject
        cell.date.text = projects[indexPath.row].DateCreated
        cell.backgroundColor = .gray
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = projects[indexPath.row]
        print(selected)
//        performSegue(withIdentifier: "show", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
}

