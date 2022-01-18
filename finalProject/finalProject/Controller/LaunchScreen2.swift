//
//  LaunchScreen.swift
//  finalProject
//
//  Created by nouf on 17/01/2022.
//

import UIKit

class LaunchScreen2: UIViewController {


    var logo = UIImageView(frame: CGRect(x: 0, y: 0, width:200, height: 200))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logo)
  logo.image = UIImage(named: "kisspng-source-code-editor-text-editor-editing-computer-so-5cb40e55518ce5.074617431555304021334-2")
       
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logo.center = view.center
       
        DispatchQueue.main.asyncAfter(deadline: .now()+0.9, execute: {
                        self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 3, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.logo.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
        })
        UIView.animate(withDuration: 1, animations: {
            self.logo.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
      
                    let guestTabBar = self.storyboard?.instantiateViewController(withIdentifier: "GuestTabBar")
                    as! GuestTabBar
                   guestTabBar.modalPresentationStyle = .fullScreen
                    self.present(guestTabBar, animated: true , completion: nil)
                   
                })
            }
        })
    }
}
