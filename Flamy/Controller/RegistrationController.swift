//
//  RegistrationControllerViewController.swift
//  Flamy
//
//  Created by as on 9/1/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    let registrationViewModel  = RegistrationViewModel()

   
    let selectPhotoBtn: UIButton = {
       let btn = UIButton(type: .system)
       btn.setTitle("Select Photo", for: .normal)
       btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
       btn.backgroundColor = .white
       btn.setTitleColor(.black, for: .normal)
       btn.heightAnchor.constraint(equalToConstant: 275).isActive = true
       btn.layer.cornerRadius = 16
       btn.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
       btn.clipsToBounds = true
       btn.imageView?.contentMode = .scaleAspectFill
       btn.clipsToBounds = true
       btn.layer.masksToBounds = true

 
       return btn
     }()
    
  
    let registerBtn    = makeButton(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), title: "Register", heightAnchor: 30)

    
    let nameTextField = makeTextField(placeHolder: "enter your name")
    let emailTextField = makeTextField(placeHolder: "enter your email")
    let passwordTextField = makeTextField(placeHolder: "enter your password")
    
 

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupGradientLayer()
        setUpLayout()
        setUpNotificationObserver()
        setUpTapgesture()
        ButtonEnablingTrigger()
        setUpRegistrationViewModelObserver()

        registerBtnTapped()
    
  

    }
    

    
    
      
      @objc func handleSelectPhoto() {
          print("image")
          let imagePickerController = UIImagePickerController()
          present(imagePickerController,animated: true)

          imagePickerController.delegate = self
      }
    
    
    
    
    
    let registerHud = JGProgressHUD(style: .dark)
    
    fileprivate func registerBtnTapped() {
          registerBtn.addTarget(self, action: #selector(handleRegisterBtn), for: .touchUpInside)
      }
    
    @objc func handleRegisterBtn() {
        
       
        
        registrationViewModel.performRegistration {[unowned self] (err) in
            if let err = err {
                self.showHudWitherror(error: err)
            }
        }
 
        
 
    }
    
    fileprivate func showHudWitherror(error : Error) {
        registerHud.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed to register"
        hud.detailTextLabel.text = "\(error.localizedDescription)"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4, animated: true)
        hud.cornerRadius = 12
  
    }
    
    
    fileprivate func setUpRegistrationViewModelObserver() {
        registrationViewModel.isformValidBindable.bind  {[unowned self] (isFormvalid) in
            guard let isFormvalid = isFormvalid else {return}
            self.registerBtn.isEnabled = isFormvalid
            
            if isFormvalid {
                self.registerBtn.backgroundColor = #colorLiteral(red: 0.6066899896, green: 0.1236705706, blue: 0.2498068213, alpha: 1)
                self.registerBtn.setTitleColor(.white, for: .normal)
            }
            else {
                self.registerBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                self.registerBtn.setTitleColor(.darkGray, for: .normal)
            }
            
            self.registrationViewModel.registerBibdable.bind {[unowned self] (isRegistering) in
                if isRegistering == true {
                    
                    self.registerHud.textLabel.text = "Registering...."
                    self.registerHud.show(in: self.view)
                }
                else{
                    self.registerHud.dismiss()
                }
            }
            
        }
        
        
       
        
        registrationViewModel.imageBindable.bind { [unowned self] (img) in
        
        
        self.selectPhotoBtn.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
            
            
            
        
    }
    
    fileprivate func ButtonEnablingTrigger() {
        nameTextField.addTarget(self, action: #selector(handleTextChange), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(handleTextChange), for: .allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(handleTextChange), for: .allEditingEvents)
    }
    
    let gradientLayer = CAGradientLayer()

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        
    }
    
    //Mark:-keyboard handling
     //____________________________________________________________
    
    fileprivate func setUpTapgesture() {
       
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
          self.view.transform = .identity
        })
    }
    
 
    
    fileprivate func setUpNotificationObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    @objc func  handleKeyboardHide() {
   
        view.transform = .identity // take back to the previous place
    }
    
    @objc func handleKeyboard(notification:Notification) {
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - overAllstackView.frame.origin.y - overAllstackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
        
        
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        //NotificationCenter.default.removeObserver(self) // to avoid retain cycle
    }
    
    //______________________________________________________________________
    
    
    lazy var overAllstackView = UIStackView(arrangedSubviews: [
                
                selectPhotoBtn,
                verticalStackView
                
            ])
    
    lazy var verticalStackView : UIStackView = {
        
        
        let sv = UIStackView(arrangedSubviews: [
        
        
        nameTextField,
        emailTextField,
        passwordTextField,
        registerBtn
        
        ])
        
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 8
        
        
        return sv
    }()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            overAllstackView.axis = .horizontal
        }
        else {
            overAllstackView.axis = .vertical
        }
    }
    
    
    static func makeTextField(placeHolder:String)->UITextField {
        let tf = CustomTextField()
        tf.placeholder = placeHolder
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 16
        return tf
    }
    
    @objc func handleTextChange(textField:UITextField) {
        
        if textField == nameTextField{
        
            registrationViewModel.fullname = textField.text
        }
        else if textField == emailTextField{
            registrationViewModel.email = textField.text
        }
        else{
            registrationViewModel.password = textField.text
        }
    }
    
    
    
  
    
    static func
        makeButton(color : UIColor , title : String , heightAnchor : CGFloat ) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = color
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.darkGray, for: .disabled)
        btn.isEnabled = false
        btn.setTitle(title, for: .normal)
        btn.layer.cornerRadius = 16
        btn.heightAnchor.constraint(greaterThanOrEqualToConstant: heightAnchor).isActive = true
        return btn
    }
    
    fileprivate func setUpLayout() {
        
         
         view.addSubview(overAllstackView)
         overAllstackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
         overAllstackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         overAllstackView.axis = .vertical
         overAllstackView.spacing = 8
     }
    
    
    fileprivate func setupGradientLayer() {
        let topcolor = #colorLiteral(red: 1, green: 0.4428480268, blue: 0.4433112144, alpha: 1)
        let bottomcolor = #colorLiteral(red: 0.8841410279, green: 0.1157724187, blue: 0.4564526677, alpha: 1)
        gradientLayer.colors = [topcolor.cgColor,bottomcolor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    
    }
    
}

class CustomTextField : UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    
    
override var intrinsicContentSize : CGSize {
    return .init(width: 0, height: 50)

}
    
}


extension RegistrationController :  UIImagePickerControllerDelegate & UINavigationControllerDelegate {



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //registrationViewModel.image = image
        registrationViewModel.imageBindable.value = image
        selectPhotoBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

        dismiss(animated: true, completion: nil)
    
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
