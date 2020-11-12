//
//  TopNavigaitonStackView.swift
//  Flamy
//
//  Created by as on 8/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

class TopNavigaitonStackView: UIStackView {
    
    let messageButton = UIButton(type: .system)
    let settingsButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "fire"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        fireImageView.contentMode = .scaleAspectFit
        
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        settingsButton.setImage(#imageLiteral(resourceName: "man").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "chat").withRenderingMode(.alwaysOriginal), for: .normal)


        
        
        [settingsButton,UIView(),fireImageView,UIView(),messageButton].forEach { (view) in
            addArrangedSubview(view)
        }
        
//        let subviews = [#imageLiteral(resourceName: "man"),#imageLiteral(resourceName: "fire"),#imageLiteral(resourceName: "chat"),].map { (button) -> UIView in
//
//
//            let btn = UIButton(type: .system)
//            btn.setImage(button.withRenderingMode(.alwaysOriginal), for: .normal)
//            return btn
//         }
//
//
//        subviews.forEach { (v) in
//            addArrangedSubview(v)
//        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
