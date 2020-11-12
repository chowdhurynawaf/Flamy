//
//  HomeBottomControlStackView.swift
//  Flamy
//
//  Created by as on 8/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {
    
    static func makebutton(image:UIImage) -> UIButton{
     
        
        let btn = UIButton(type: .system)
        btn.contentMode = .scaleAspectFill
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
        
    }
    
    
   let refreshButton = makebutton(image: #imageLiteral(resourceName: "refresh"))
   let dislikeButton = makebutton(image: #imageLiteral(resourceName: "dismiss"))
   let  superLikeButton = makebutton(image: #imageLiteral(resourceName: "superlike"))
   let likeButton = makebutton(image: #imageLiteral(resourceName: "like"))
   let specialButton = makebutton(image: #imageLiteral(resourceName: "boost"))
    
    
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//       let bottomSubView =  [ #imageLiteral(resourceName: "dismiss"),#imageLiteral(resourceName: "refresh"),#imageLiteral(resourceName: "boost"),#imageLiteral(resourceName: "superlike"),#imageLiteral(resourceName: "like")].map { (btn) -> UIView in
//            let button = UIButton(type: .system)
//        button.setImage(btn.withRenderingMode(.alwaysOriginal), for: .normal)
//            return button
//        }
        
        //let button = UIButton(type: .system)
        
        [refreshButton,dislikeButton,superLikeButton,likeButton,specialButton].map { (btn) in
            self.addArrangedSubview(btn)
        }
        
        
        
        
        //distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        contentMode = .scaleToFill

        
        
//        bottomSubView.forEach { (v) in
//        addArrangedSubview(v)
//        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 2, bottom: 0, right: 2)
        

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    
    
    
    
}
