//
//  RestBindTextView.swift
//  Alamofire
//
//  Created by Daniel Amaral on 16/02/18.
//

import UIKit

open class DataBindTextView: UITextView, DataBindable {
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var required: Bool = false
    @IBInspectable open var requiredError: String = ""
    @IBInspectable open var fieldPath: String = ""
    
}

