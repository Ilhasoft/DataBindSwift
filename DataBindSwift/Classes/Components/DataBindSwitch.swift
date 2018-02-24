//
//  RestBindSwitch.swift
//  Alamofire
//
//  Created by Daniel Amaral on 16/02/18.
//

import UIKit

open class DataBindSwitch: UISwitch, DataBindable {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var required: Bool = false
    @IBInspectable open var requiredError: String = ""
    @IBInspectable open var fieldPath: String = ""
    
}

