//
//  SettingsCell.swift
//  Flamy
//
//  Created by as on 9/7/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit


class SettingsCell : UITableViewCell {
    
    
    
    class SettingTextField : UITextField {
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 44)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
              return bounds.insetBy(dx: 16, dy: 0)
          }
          
          override func editingRect(forBounds bounds: CGRect) -> CGRect {
              return bounds.insetBy(dx: 16, dy: 0)
          }
    }
    
    let textField : UITextField = {
        let tf = SettingTextField()
        //tf.placeholder = "enter your name"
        func textRect(forBounds bounds: CGRect) -> CGRect {
                   return bounds.insetBy(dx: 16, dy: 0)
               }
               
        func editingRect(forBounds bounds: CGRect) -> CGRect {
                   return bounds.insetBy(dx: 16, dy: 0)
               }
        
        return tf
    }()
    
   
    override var intrinsicContentSize : CGSize {
        return .init(width: 0, height: 50)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
