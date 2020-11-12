//
//  Advertiser.swift
//  Flamy
//
//  Created by as on 8/29/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

struct Advertiser : ProducecardViewModel {
    let title : String
    let brandName : String
    let posterImageName : String
    
    
    
    
    func toCardModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy) ])
        attributedText.append(NSAttributedString(string: brandName, attributes: [.font : UIFont.systemFont(ofSize: 25, weight: .regular)]))
        
        
        
        return CardViewModel(imageNames: [posterImageName], attributedString: attributedText, textAlignment: .center)
        
        
    }
}
