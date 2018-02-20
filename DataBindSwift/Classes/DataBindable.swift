//
//  DataBindable.swift
//  Voy
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

@objc public protocol DataBindable {
    
    var required: Bool { get set }
    var requiredError: String { get set }
    var fieldType: String { get set }
    var fieldTypeError: String { get set }
    var fieldPath: String { get set }
    var persist: Bool { get set }
    
}
