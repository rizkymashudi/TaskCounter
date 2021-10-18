//
//  Box.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 17/10/21.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    
    // MARK: -variables
    var value: T {
        didSet {
            listener?(value) 
        }
    }
    
    var listener: Listener?
    
    // MARK: -inits
    
    init(_ value: T) {
        self.value = value
    }
    
    //MARK: -functions
    func blind(listener: Listener?) {
        self.listener = listener
    }
    
    func removeBinding(){
        self.listener = nil
    }
}
