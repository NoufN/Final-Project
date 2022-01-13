//
//  HomeGuestVC.swift
//  finalProject
//
//  Created by nouf on 12/01/2022.
//

import UIKit
import Firebase

class HomeGuestVC: UIViewController ,  UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,  UISearchBarDelegate {
    
    
    
    
    var projects = [Projects]()
 
    


    @IBOutlet weak var collectionView : UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    var selected : Projects? = nil
  
    
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email

    
//   var projects = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllProjects()
 collectionView.delegate = self
    collectionView.dataSource = self
 
      
    
 
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadAllProjects()

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
             
                    self.projects.append(Projects(IdProject:data["ProjectID"] as? String ?? "" , nameProject: data["Title"] as? String ?? "", detailsProject: data["Details"] as? String ?? "", Deadline: data["Deadline"] as? String ?? "" , ConnectionTool: data["ConnectionTool"] as? String ?? "", DateCreated: data["DateCreated"] as? String ?? "", specializayion:  data["specializayion"] as? String ?? "", nameUser:  data["nameUser"] as? String ?? "", email: data["emailUser"] as? String ?? "", image: data["imageProfile"] as? String ?? ""))
                        
                        
                        
                        
                       
        
                   
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            }
        }
    }
    
    func loadLikeProjects(){

            
                    projects.removeAll()
                        db.collection("Projects").whereField( "Likes", isEqualTo: email!).addSnapshotListener{(querySnapshot, error) in
                        
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
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if(!(searchBar.text?.isEmpty)!){
//            print("hgfd")
////            var  filteredProject = [Projects]()
//            for project in projects {
//                let name = project.nameProject.lowercased()
//                let details = project.detailsProject.lowercased()
//                if name.contains(searchBar.text!.lowercased()  ) ||  details.contains(searchBar.text!.lowercased() ){
//                  print(name , details)
//            self.collectionView?.reloadData()
//        }
//            }
//
//        }
//        }
//
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){

    
                 for project in projects {
                     let name = project.nameProject.lowercased()
                     let details = project.detailsProject.lowercased()
                     if name.contains(searchBar.text!.lowercased()  ) ||  details.contains(searchBar.text!.lowercased() ){

                         DispatchQueue.main.async {
                                              self.collectionView.reloadData()
                      
                                          }
                         print(name.self , details.self)

             }
            }
     
                 }
  
      
             }
            

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            loadAllProjects()
//            project.selectedSegmentIndex == 0 ? loadAllProjects() : loadLikeProjects()
         
        } else {
            print ("pokjhgfdsfghjkl;")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
                cell.backgroundColor = #colorLiteral(red: 0.9032060504, green: 0.9586966634, blue: 0.9618744254, alpha: 1)
                cell.layer.cornerRadius = 10
       
                return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = projects[indexPath.row]
        performSegue(withIdentifier: "show", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let nextVC = segue.destination as!  DetailsProjectsAsGuestVC
            nextVC.projects = selected


        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width:  collectionView.layer.bounds.width , height: (view.layer.bounds.height)/6)
        
    }
    

    
}
//extension HomeForDevelopersVC : UISearchBarDelegate {
//
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if(!(searchBar.text?.isEmpty)!){
////            var  filteredProject = [Projects]()
//            for project in projects {
//                let name = project.nameProject.lowercased()
//                let details = project.detailsProject.lowercased()
//                if name.contains(searchBar.text!.lowercased()  ) ||  details.contains(searchBar.text!.lowercased() ){
//                  print(name , details)
//            self.collectionView?.reloadData()
//        }
//            }
//
//        }
//        }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if(searchText.isEmpty){
//            project.selectedSegmentIndex == 0 ? loadAllProjects() : loadLikeProjects()
//
//        }
//    }
//}

