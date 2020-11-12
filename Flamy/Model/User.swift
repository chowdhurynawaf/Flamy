//
//  User.swift
//  Flamy
//
//  Created by as on 8/28/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit


public struct User : ProducecardViewModel {
    var name : String?
    var age : Int?
    var profession : String?
//    let imgNames : [String]
    var imageURL1 : String?
    var imageURL2 : String?
    var imageURL3 : String?
    var uid : String
    var bio : String?
    
    init(dictionary:[String:Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageURL1 = dictionary["imageURL"] as? String
        self.imageURL2 = dictionary["imageURL2"] as? String
        self.imageURL3 = dictionary["imageURL3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        
    }

    func toCardModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/a"
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? "\(profession!)" : "Not Available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font:UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        
        var imageURLS = [String]()
        if let url = imageURL1 {imageURLS.append(url)}
        if let url = imageURL1 {imageURLS.append(url)}
        if let url = imageURL1 {imageURLS.append(url)}
        
        return CardViewModel(imageNames: imageURLS, attributedString: attributedText, textAlignment: .left)
        
    }
}

