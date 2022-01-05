//
//  ShowDevelopersVC.swift
//  finalProject
//
//  Created by nouf on 01/01/2022.
//

import UIKit
import Firebase

class ShowDevelopersVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {

    let db = Firestore.firestore()
    var developer = [Developers]()
    var selected : Developers? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadData()
    }

    func loadData(){
        developer.removeAll()
        db.collection("Users").whereField("taypUser", isEqualTo: "Developers").getDocuments { querySnapshot, error in
        
        if let err = error {
            print("Error getting documents: \(err.localizedDescription)")
        } else {
            self.developer.removeAll()
            for document in querySnapshot!.documents {
                let data = document.data()
                let nameImage = data["image"] as? String ?? ""
                self.developer.append(Developers(emailUser: data["emailUser"] as! String , image: nameImage , userName: data["userName"] as! String, Bio: data["Bio"] as? String ?? "", JobTitle: data["JobTitle"] as? String ?? "", website: data["website"] as? String ?? ""))
                print(document.data())
                print(self.developer.isEmpty)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
            
        }
        
    }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeveloperCell", for: indexPath) as! DeveloperCell
        cell.nameUser.text = developer[indexPath.item].userName
        cell.jobTitle.text = developer[indexPath.item].JobTitle
        cell.imageUser.image = UIImage(named: "\(developer[indexPath.item].image)")
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 15
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = developer[indexPath.row]
        performSegue(withIdentifier: "show", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let nextVC = segue.destination as! DetailsDeveloper
            nextVC.developer  = selected
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                                  minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0.1
     }
    
      func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat{
         
          return 10
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
     }
   
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
         {
             return CGSize(width: self.view.frame.width * 0.45 , height: self.view.frame.width * 0.45 )
             
         }
}
