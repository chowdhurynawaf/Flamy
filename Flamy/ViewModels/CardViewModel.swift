//
//  CardViewModel.swift
//  Flamy
//
//  Created by as on 8/29/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

protocol ProducecardViewModel {
    
    func toCardModel() -> CardViewModel 
}

class CardViewModel {
    let imageNames : [String]
    let attributedString : NSAttributedString
    let textAlignment    : NSTextAlignment
    
    init(imageNames:[String],attributedString : NSAttributedString,textAlignment    : NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        
    }
    
    fileprivate var Imageindex = 0 {
        didSet{
            
            let imageURL = imageNames[Imageindex]
            //let image = UIImage(named: imageURL)
            //let idx = Imageindex
            imageIndexObserver?(Imageindex,imageURL)
        }
    }
    
    var imageIndexObserver : ((Int,String)->())?
    
    func advanceToNextPhoto() {
        Imageindex = min(Imageindex + 1 ,imageNames.count - 1)
    }
    
    func goToPreviousphoto() {
        Imageindex = max(0,Imageindex - 1)
    }
}

