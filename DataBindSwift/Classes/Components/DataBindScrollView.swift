//
//  RestBindScrollView.swift
//  Alamofire
//
//  Created by Daniel Amaral on 09/02/18.
//

import UIKit

open class DataBindScrollView: UIScrollView, DataBindable {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var required: Bool = false
    public var requiredError: String = ""
    public var fieldType: String = "None"
    public var fieldTypeError: String = ""
    @IBInspectable open var fieldPath: String = ""
    public var persist: Bool = false
    
}

