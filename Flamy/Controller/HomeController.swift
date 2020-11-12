//
//  HomeController.swift
//  Flamy
//
//  Created by as on 7/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigaitonStackView()
    let buttonStackView = HomeBottomControlStackView()
    let cardsDeckView = UIView()
    
    
//    let cardVm = [
//
//        User(name: "kelly", age: 23, profession: "DJ", imageName: "cardView"),
// User(name: "jenny", age: 18, profession: "Teacher", imageName: "cardView2"),
//
//
// User(name: "adf", age: 34, profession: "Adf", imageName: "Adf").toCardModel()
//
//
//        ]
    
    var lastFetchedUser : User?
    var cardViewModels = [CardViewModel]()
        
//        let producer = ([
//
//                User(name:"kelly",age:23 , profession:"DJ",imgNames:["cardView" , "jane2" , "jane3"]),
//                User(name:"jenny",age:34,profession:"Teacher",imgNames:["cardView2","kelly2","kelly3"]),
//                Advertiser(title: "yahoooooo", brandName: "\nlets build it", posterImageName: "slack")
//
//                ] as [ProducecardViewModel])
//
//        let viewModel = producer.map({return $0.toCardModel()})
//        return viewModel
//
//    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettingsBtn), for: .touchUpInside)
        
        buttonStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setUpLayout()
        setUpUsersCardsFromFireStore()
        fetchUsersFromFireStore()
        
      
        

    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFireStore()
    }
    
    
    fileprivate func fetchUsersFromFireStore() {
        var prog = JGProgressHUD()
            prog.show(in: view)
        let query = Firestore.firestore().collection("usersofFlamy").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
//       let query = Firestore.firestore().collection("usersofFlamy").whereField("age", isEqualTo: 567)
        query.getDocuments { (snapshot, err) in
            prog.dismiss()
            if let err = err {
                print(err.localizedDescription)
                prog.textLabel.text = "something went wrong"
                prog.dismiss(afterDelay: 3, animated: true)
                return
            }
            
            snapshot?.documents.forEach({ (docsnapshot) in
                let dictionary = docsnapshot.data()
                let user = User(dictionary: dictionary)
                self.cardViewModels.append(user.toCardModel())
                self.lastFetchedUser = user
                self.setUpCardFromuser(user: user)
            })
            
           // self.setUpUsersCardsFromFireStore()
        }
    }
    
    fileprivate func setUpCardFromuser(user:User) {
        
        
        let cardView = CardView(frame:.zero)
        cardView.cardViewModel = user.toCardModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    
    @objc func handleSettingsBtn() {
        let settingsController =  SettingsController()
        let navcontroller = UINavigationController(rootViewController: settingsController)
        present(navcontroller, animated: true)
        //navigationController?.pushViewController(navcontroller, animated: true)
        
    }
    
    fileprivate func setUpUsersCardsFromFireStore() {
        
        cardViewModels.forEach { (cardVM) in
            
            let cardView = CardView(frame:.zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            
        }

    }
    
    fileprivate func setUpLayout() {
        view.backgroundColor = .white
        let overAllStackView = UIStackView(arrangedSubviews: [
            topStackView ,
            cardsDeckView ,
            buttonStackView
        ])
        
        view.addSubview(overAllStackView)
        overAllStackView.axis = .vertical
        
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
       // overAllStackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        overAllStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        overAllStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)

        overAllStackView.bringSubviewToFront(cardsDeckView)
    }


}

