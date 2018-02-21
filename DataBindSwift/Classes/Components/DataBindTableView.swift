//
//  DataBindTableView.swift
//  DataBindSwift
//
//  Created by Daniel Amaral on 21/02/18.
//

import UIKit

open class DataBindTableView: UITableView, DataBindable {
    
    public var dataList = [Any]()
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var required: Bool = false
    @IBInspectable open var requiredError: String = ""
    @IBInspectable open var fieldType: String = "Array"
    @IBInspectable open var fieldTypeError: String = ""
    @IBInspectable open var fieldPath: String = ""
    @IBInspectable open var persist: Bool = true
    
}

