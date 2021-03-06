//
//  HomeForDevelopersVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class HomeForDevelopersVC: UIViewController  ,  UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UISearchBarDelegate {
    
    
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var projects = [Projects]()
    var selected : Projects? = nil
    let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email
    var filteredData : [Projects]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllProjects()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        self.filteredData =     self.projects
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadAllProjects()
        
    }
    
    
    // load data from fierbase
    
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
                    self.filteredData =     self.projects
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            }
        }
    }
    
    // search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = [Projects]()
        if searchBar.text == "" {
            filteredData = projects
            loadAllProjects()
        }else{
            for project in projects {
                let name = project.nameProject.lowercased()
                let details = project.detailsProject.lowercased()
                if name.contains(searchBar.text!.lowercased()  ) ||  details.contains(searchBar.text!.lowercased() ){
                    
                    filteredData?.append(project)
                    
                }
                
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
        
        
        
        
    }
    
    
    
    
    // collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
        if (self.filteredData.count == 0) {
            self.collectionView.setEmptyMessage("لا توجد مشاريع")
           } else {
               self.collectionView.restore()
           }

        return filteredData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell" , for: indexPath) as! ProjectCell
        
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.1
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 1
        cell.layer.shadowOpacity =  0.50
        cell.layer.masksToBounds = false
        
        cell.nameProject.text = filteredData[indexPath.row].nameProject
        cell.detailsProject.text = filteredData[indexPath.row].detailsProject
        cell.specializayion.text =  filteredData[indexPath.row].specializayion
        let dateCreated =   filteredData[indexPath.row].DateCreated
        cell.date.text =  stringToDate(Date: dateCreated)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = projects[indexPath.row]
        performSegue(withIdentifier: "show", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let nextVC = segue.destination as!  DetailsProjectsVC
            nextVC.projects = selected
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width:  collectionView.layer.bounds.width , height: (view.layer.bounds.height)/6)
        
    }
    
    
    
}

