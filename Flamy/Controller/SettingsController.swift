//
//  SettingsController.swift
//  Flamy
//
//  Created by as on 9/6/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class SettingsController: UITableViewController  {
    
    
    
    class CustomePickerController : UIImagePickerController {
        var imageButton : UIButton?
        
        
    }
    
    class HeaderLabel : UILabel  {
    
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    
    lazy var btn1 = createBtn(selector: #selector(handleSelectPhoto))
    lazy var btn2 = createBtn(selector: #selector(handleSelectPhoto))
    lazy var btn3 = createBtn(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button:UIButton) {
        let imagePicker = CustomePickerController()
        present(imagePicker,animated: true)
        imagePicker.delegate = self
        imagePicker.imageButton = button
        print("picker")
    }

    @IBOutlet weak var slider: UISlider!
    
    func createBtn (selector:Selector)->UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("select photo", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.contentMode = .scaleToFill
//        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.frame = CGRect(x: 103, y: 150, width: 50, height: 50)
        btn.layer.cornerRadius = 0.5 * btn.bounds.size.width
        btn.layer.masksToBounds = true
        return btn
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        setUpnavItems()
        
       
        fetchCurrentUser()
        
      
    }
    
    var user : User?
    
    fileprivate func fetchCurrentUser() {
        let uid = "ASV24779paMDdL9Z8rOi7vjQu982" //Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("usersofFlamy").document(uid).getDocument { (snapShot, err) in
            if let err = err {
                print(err)
                return
            }
            
            else{
                guard let dictionary  = snapShot?.data() else {return}
                self.user = User(dictionary: dictionary)
                self.handleSave()
                self.loadUserPhoto()

            }
            
            self.tableView.reloadData()

            
        }
        
        
    }
    
    
    fileprivate func  loadUserPhoto() {
        
        if let imageUrl = user?.imageURL1 , let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                
                self.btn1.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            
            if let imageUrl = user?.imageURL2 , let url = URL(string: imageUrl)  {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                    
                    self.btn2.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
                
                
                if let imageUrl = user?.imageURL3 , let url = URL(string: imageUrl)  {
                    SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                        
                        self.btn3.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
                    }
                    
                }
            }
            
        }
        
    }
    fileprivate func setUpnavItems() {
          navigationItem.title = "Settings"
          navigationController?.navigationBar.prefersLargeTitles = true
          tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
          tableView.tableFooterView = UIView()
          tableView.keyboardDismissMode = .interactive
          navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
          
          navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
                                                
                                                UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
              
          ]
      }
    
    @objc func handleSave() {
        
        
        let uid = "ASV24779paMDdL9Z8rOi7vjQu982" //Auth.auth().currentUser?.uid else {return}
        let docdata :[String:Any] = [
        
            "fullName" : user?.name ?? "",
            "uid" : user?.uid,
            "imageURL" : user?.imageURL1 ?? "",
            "imageURL2" : user?.imageURL2 ?? "",
            "imageURL3" : user?.imageURL3 ?? "",
            "age" : user?.age ?? -1 ,
            "profession" : user?.profession ?? "",
            "bio" : user?.bio ?? ""
        
        ]
        
        Firestore.firestore().collection("usersofFlamy").document(uid).setData(docdata) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
            
            else{
                
                print("finished saving")
            }
        }
    }
    
    lazy var header : UIView = {
        
        let padding : CGFloat = 16
        let header = UIView()
        header.addSubview(btn1)
        btn1.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil,padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        btn1.widthAnchor.constraint(equalTo:header.widthAnchor,multiplier: 0.45).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [
        
            btn2,
            btn3
        
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        header.addSubview(stackView)

        
        stackView.anchor(top: header.topAnchor, leading: btn1.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor,padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        
        
             return header
    }()

 
    
    @objc func  handleCancel() {
        self.dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 0:1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let ageCell = AgeRangeCell()
            return ageCell
        }
        
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)

        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "enter your name"
            cell.textField.text = user?.name as? String
            cell.textField.addTarget(self, action: #selector(handleNameTextField), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "enter your age"
            if let age = user?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeTextField), for: .editingChanged)
            }
        case 3:
            cell.textField.placeholder = "enter your profession"
            cell.textField.text = user?.profession ?? ""
            cell.textField.addTarget(self, action: #selector(handleProfessionTextField), for: .editingChanged)
        default:
            cell.textField.placeholder = "enter your bio"
            cell.textField.addTarget(self, action: #selector(handleBioTextField), for: .editingChanged)
            
        }
        
        return cell
    }
    
    
    @objc func handleNameTextField(textField:UITextField) {
        self.user?.name = textField.text ?? ""
        
    }
    
    @objc func handleAgeTextField(textField:UITextField) {
        self.user?.age = Int(textField.text ?? "")

          
      }
    
    @objc func handleProfessionTextField(textField:UITextField) {
          self.user?.profession = textField.text ?? ""

      }
    
    @objc func handleBioTextField(textField:UITextField) {
          self.user?.bio = textField.text ?? ""

      }
    
    
          override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section == 0 {
                return header


            }
            else {
                
                let headerLabel = HeaderLabel()
//                return headerLabel
                
                switch section {
                case 1:
                    headerLabel.text = "Name"
                case 2:
                    headerLabel.text = "Age"
                case 3:
                headerLabel.text = "Profession"
                    
                case 4:
                     headerLabel.text = "Bio"
                default:
                    headerLabel.text = "Age Range"
                    
                }
                
                return headerLabel
            }
            

             }

             override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                
                if section == 0 {
                    return 300
                }
                else{
                    return 40
                }
                
             }
   


}

extension SettingsController :  UIImagePickerControllerDelegate & UINavigationControllerDelegate {



    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        //registrationViewModel.image = image
        let imageButton =  (picker as? CustomePickerController)?.imageButton
        imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)

        dismiss(animated: true, completion: nil)
        
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = image?.jpegData(compressionQuality: 0.75) else {return}
        
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            
            if let err = err {
                print("failed to upload")
                return
                
            }
            
            print("finshed upload")
            ref.downloadURL { (url, err) in
                if let err = err {
                    print("err")
                    return
                }
                
                print("finished getting url " , url?.absoluteString)
                
                if imageButton == self.btn1 {
                    self.user?.imageURL1 = url?.absoluteString
                    
                }
                
                else if imageButton == self.btn2 {
                    self.user?.imageURL2 = url?.absoluteString
                }
                
                else {
                    self.user?.imageURL3 = url?.absoluteString
                }
            }
            
            
          
            
        }
        
    
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

