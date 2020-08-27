//
//  CardView.swift
//  Flamy
//
//  Created by as on 8/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit

class CardView: UIView {

    fileprivate let imgView = UIImageView(image: #imageLiteral(resourceName: "cardView"))
    fileprivate let threshold : CGFloat = 80

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .red
        
        addSubview(imgView)
        imgView.fillSuperview()
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
            
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation  = gesture.translation(in: nil)
        
        let degree : CGFloat = translation.x / 20
        let angle = degree * .pi/180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
        
//        let tranlation = gesture.translation(in: nil)
//        self.transform = CGAffineTransform(translationX: tranlation.x, y: tranlation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        
        let shouldDismisscard = gesture.translation(in: nil).x > threshold || gesture.translation(in: nil).x < -80
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                
                if shouldDismisscard {
                   
                    self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
                }
                else {
                    self.transform = .identity

                }
            }) { (_) in
                
                self.transform = .identity
                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)

                
            }
        default:
            ()
        }
    }
    
    @objc fileprivate func handlePan(gesture:UIPanGestureRecognizer) {

        handleEnded(gesture)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
}
