//
//  TopNavigaitonStackView.swift
//  Flamy
//
//  Created by as on 8/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

class TopNavigaitonStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        distribution = .equalSpacing
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let subviews = [#imageLiteral(resourceName: "man"),#imageLiteral(resourceName: "fire"),#imageLiteral(resourceName: "chat"),].map { (button) -> UIView in
      
            
            let btn = UIButton(type: .system)
            btn.setImage(button.withRenderingMode(.alwaysOriginal), for: .normal)
            return btn
         }
        
        
        subviews.forEach { (v) in
            addArrangedSubview(v)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
