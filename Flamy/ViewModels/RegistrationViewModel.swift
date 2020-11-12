//
//  RegistrationViewModel.swift
//  Flamy
//
//  Created by as on 9/3/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var fullname : String?  {didSet{checkIsFormValid()}}
    var email : String?  {didSet{checkIsFormValid()}}
    var password : String? {didSet{checkIsFormValid()}}

    
    var imageBindable = Bindable<UIImage>()
    var isformValidBindable = Bindable<Bool>()
    var registerBibdable = Bindable<Bool>()
    
    func checkIsFormValid() {
               let isformValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
        isformValidBindable.value = isformValid
        
    }
    
    func performRegistration(completion: @escaping (Error?)->()) {
        guard let email = email , let pass = password else {return}
        registerBibdable.value = true

        
        Auth.auth().createUser(withEmail: email, password: pass) { (res, err) in
             if let err = err {
                 print(err.localizedDescription)
                 completion(err)
                 return
                 
             }
             
             else {
                 print("uesr", res?.user.uid)
                
                self.saveImageToFirebase(completion: completion)
                 
            
             }
            
                
                
                
            }

         }
    
    
  
    
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?)->()) {
        
        
        let fileName = UUID().uuidString
                    let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
                    let imageData = self.imageBindable.value?.jpegData(compressionQuality: 0.80) ?? Data()
                    ref.putData(imageData, metadata: nil) { (_, err) in
                        if let err = err {
                            completion(err)
                            return
                        }
                        print("uploaded done")
                        ref.downloadURL { (url, err) in
                            if let err = err {
                                completion(err)
                                return
                            }
                            print("image url is ", url)
                            self.registerBibdable.value = false
                            
                            //store firestore values
                            let imageURL = url?.absoluteString ?? ""
                            
                            self.saveInfoToFireStore(imageURL:imageURL,completion: completion)
                            
                            
                            completion(nil)
                            
                            
                        }
                    }
        
        
    }
    
    fileprivate func saveInfoToFireStore(imageURL:String,completion:@escaping (Error?)->()) {
          
          let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName":fullname ?? "","uid":uid , "imageURL":imageURL]
          Firestore.firestore().collection("usersofFlamy").document(uid).setData(docData) { (err) in
              if let err = err {
                  completion(err)
                  return
              }
              completion(nil)
          }
          
      }

    }
    
    


