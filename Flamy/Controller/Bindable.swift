//
//  Bindable.swift
//  Flamy
//
//  Created by as on 9/5/20.
//  Copyright © 2020 nawaf. All rights reserved.
//

import Foundation


class Bindable<T>
    
{
    var value : T? {
        didSet{
            observer?(value)
        }
    }
    
    var observer:((T?)->())?
    
    func bind(observer:@escaping (T?)->()) {
        self.observer = observer
    }
}
