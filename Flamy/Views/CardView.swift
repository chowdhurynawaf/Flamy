//
//  CardView.swift
//  Flamy
//
//  Created by as on 8/27/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD

class CardView: UIView {

    fileprivate let imgView = UIImageView(image: #imageLiteral(resourceName: "cardView"))
    fileprivate let threshold : CGFloat = 80
    fileprivate let informationLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    
    var cardViewModel : CardViewModel! {
        
        didSet {
            
            let imageName = cardViewModel.imageNames.first ?? ""
            
            if let url = URL(string: imageName){
    
                
                imgView.sd_setImage(with: url)
            }
//            imgView.image = UIImage(named: cardViewModel.imageNames.first ?? "")
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barStackView.addArrangedSubview(barView)
            }
            
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            setUpIndexObserer()
                
        }
        
        
    }
    
    func setUpIndexObserer() {
        cardViewModel.imageIndexObserver = {[unowned self](idx,imageUrl) in
            
            if let url = URL(string: imageUrl ?? "")
            {
                self.imgView.sd_setImage(with: url)
            }
            
//            self.imgView.image = image
            
            self.barStackView.arrangedSubviews.forEach { (v) in
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
            }
            
            self.barStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }

    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  
            
    }
    
    var imageIndex = 0
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        
        let location = gesture.location(in: nil)
        let advanceNextPhoto = location.x > frame.width / 2 ? true : false
        
        if advanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        }
        else {
            cardViewModel.goToPreviousphoto()
        }
        
    }
    
    fileprivate func setUpLayout() {
        backgroundColor = .red
        
        imgView.contentMode = .scaleAspectFill
        addSubview(imgView)
        imgView.fillSuperview()
        setUpBarStackView()

        setUpGradientLayer()
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor , padding: .init(top: 0, left: 16, bottom: 16, right: 0))
        informationLabel.textColor = .red
        informationLabel.numberOfLines = 0
        informationLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    
    
    fileprivate let barStackView = UIStackView()
    
    fileprivate func setUpBarStackView()
    {
       addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        barStackView.arrangedSubviews.first?.backgroundColor = .white
    }
    
        @objc func handlePan(gesture:UIPanGestureRecognizer) {

        handleEnded(gesture)
        
            switch gesture.state {
            case .began:
                superview?.subviews.forEach({ (subViews) in
                    subViews.layer.removeAllAnimations()
                })
            case .changed:
                handleChanged(gesture)
            case .ended:
                handleEnded(gesture)
            default:
                ()
            }
        
    }
    
    
    func setUpGradientLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations  = [0.5,1.1]
        layer.addSublayer(gradientLayer)
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        
        let translationDirection : CGFloat  = gesture.translation(in: nil).x > 0 ? 1:-1
        let shouldDismisscard = abs(gesture.translation(in: nil).x ) > threshold
        
        
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                
                
                if shouldDismisscard {
                   
            self.frame = CGRect(x: 600 * translationDirection , y: 0, width: self.frame.width, height: self.frame.height)
                }
                else {
                    self.transform = .identity

                }
            }) { (_) in
                
                self.transform = .identity
                
                if shouldDismisscard {
                    self.removeFromSuperview()
                }
//                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)

                
            }
        
        
        
    


    
    
}

}
