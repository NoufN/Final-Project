//
//  HomeForClientVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class HomeForClientVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    
    var projects = [Projects]()
    var initialCenter = CGPoint()
    
    
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var project: UISegmentedControl!

    
    var selected : Projects? = nil
    
    
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        addProjectButton.layer.cornerRadius = 0.5 * addProjectButton.bounds.size.width
        addProjectButton.clipsToBounds = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        project.selectedSegmentIndex == 0 ? loadAllProjects() : loadMyProjects()
        
    }
    
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        project.selectedSegmentIndex == 0 ? loadAllProjects() : loadMyProjects()
    }
    
    
    
    
    
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
        db.collection("Projects").order(by: "DateCreated", descending: true).addSnapshotListener{(querySnapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err.localizedDescription)")
                if self.projects.isEmpty {
                    self.collectionView.isHidden = true
                    let label = UILabel(frame: CGRect(x: 0, y: 0,width: self.collectionView.layer.bounds.width , height: self.collectionView.layer.bounds.height))
                    label.text = "حدث خطاء"
//                    label.textColor = .black
                    self.view.addSubview(label)
                }
            } else {
                self.projects.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    self.projects.append(Projects(IdProject:data["ProjectID"] as? String ?? "" , nameProject: data["Title"] as? String ?? "", detailsProject: data["Details"] as? String ?? "", Deadline: data["Deadline"] as? String ?? "" , ConnectionTool: data["ConnectionTool"] as? String ?? "", DateCreated: data["DateCreated"] as? String ?? "", specializayion:  data["specializayion"] as? String ?? "", nameUser:  data["nameUser"] as? String ?? "", email: data["emailUser"] as? String ?? "", image: data["imageProfile"] as? String ?? ""))
                
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            }
        }
    }
    
    func loadMyProjects(){
        projects.removeAll()
        db.collection("Projects").whereField( "emailUser", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
            
            if let err = error {
                print("Error getting documents: \(err.localizedDescription)")
                
             
                
            } else {
                self.projects.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    self.projects.append(Projects(IdProject:data["ProjectID"] as? String ?? "" , nameProject: data["Title"] as? String ?? "", detailsProject: data["Details"] as? String ?? "", Deadline: data["Deadline"] as? String ?? "" , ConnectionTool: data["ConnectionTool"] as? String ?? "", DateCreated: data["DateCreated"] as? String ?? "", specializayion:  data["specializayion"] as? String ?? "", nameUser:  data["nameUser"] as? String ?? "", email: data["emailUser"] as? String ?? "", image: data["imageProfile"] as? String ?? ""))
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            }
            
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if (self.projects.count == 0) {
            self.collectionView.setEmptyMessage("لا توجد مشاريع")
           } else {
               self.collectionView.restore()
           }

        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell" , for: indexPath) as! ProjectCell
        //
        cell.nameProject.text = projects[indexPath.row].nameProject
        cell.detailsProject.text = projects[indexPath.row].detailsProject
        cell.specializayion.text = projects[indexPath.row].specializayion
        let dateCreated =  projects[indexPath.row].DateCreated
        
        cell.date.text =  stringToDate(Date: dateCreated)
        id = projects[indexPath.row].IdProject
        
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.1
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity =  0.50
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = projects[indexPath.row]
        if  project.selectedSegmentIndex == 1 {
            
            performSegue(withIdentifier: "ShowVC", sender: nil)
            
        } else if  project.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "show", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let nextVC = segue.destination as!  DetailsProjectsVC
            nextVC.projects = selected
            
        } else  if segue.identifier == "ShowVC" {
            let VC = segue.destination as!  ShowEditProject
            VC.projects = selected
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width:  collectionView.layer.bounds.width , height: (view.layer.bounds.height)/6)
        
    }
    
}
