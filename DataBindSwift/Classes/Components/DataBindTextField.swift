//
//  RestBindTextField.swift
//  Alamofire
//
//  Created by Daniel Amaral on 16/02/18.
//

import UIKit

open class DataBindTextField: UITextField, DataBindable {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var required: Bool = false
    @IBInspectable open var requiredError: String = ""
    @IBInspectable open var fieldType: String = "Text"
    @IBInspectable open var fieldTypeError: String = ""
    @IBInspectable open var fieldPath: String = ""
    @IBInspectable open var persist: Bool = true
    
}

