//
//  Action.swift
//  TattooScheduler
//
//  Created by Artem on 23.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

public class ClosureSelector<Parameter> {
    
    public let selector : Selector
    private let closure : ( Parameter ) -> ()
    
    init(withClosure closure : @escaping ( Parameter ) -> ()){
        self.selector = #selector(ClosureSelector.target(param:))
        self.closure = closure
    }
    
    @objc func target( param : AnyObject) {
        closure(param as! Parameter)
    }
}
