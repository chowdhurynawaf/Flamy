//
//  ViewController.swift
//  Flamy
//
//  Created by as on 7/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigaitonStackView()
    let buttonStackView = HomeBottomControlStackView()
    let cardsDeckView = UIView()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setUpLayout()
        setUpDummyCards()

    }
    
    fileprivate func setUpDummyCards() {
        
        let cardView = CardView()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
        
    }
    
    fileprivate func setUpLayout() {
        let overAllStackView = UIStackView(arrangedSubviews: [
            topStackView ,
            cardsDeckView ,
            buttonStackView
        ])
        
        view.addSubview(overAllStackView)
        overAllStackView.axis = .vertical
        
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        overAllStackView.bringSubviewToFront(cardsDeckView)
    }


}

