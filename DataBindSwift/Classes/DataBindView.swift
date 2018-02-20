//
//  DataBindView.swift
//  DataBindSwift
//
//  Created by Daniel Amaral on 07/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit
import Kingfisher

public protocol DataBindViewDelegate {
    func didFetch(error:Error?)
    func willFill(component:Any, value:Any) -> Any?
    func didFill(component:Any, value: Any)
    func willSet(component:Any, value:Any) -> Any?
    func didSet(component:Any, value: Any)
}

public class DataBindView: UIView {

    @IBOutlet open var fields:[AnyObject]!
    
    private var isFieldSorted = false
    private var currentKeyPath = [String]()
    private var nextObjectQueue = [[String:[String:Any]]]()
    var fetchedObject:[String:Any]!
    public var fieldAndValues = [[String:Any]]()
    public var delegate:DataBindViewDelegate?
    
    private func sortFields() {
        if isFieldSorted == true {
            return
        }
        var bindableComponentsInSubView =  [UIView]()
        
        let fieldsNotDataBindable = fields.filter {(!($0 is DataBindable))}
        for component in fieldsNotDataBindable as! [UIView] {
            let bindableComponents = component.getSubviewsOfView(recursive: true) as! [UIView]
            bindableComponentsInSubView.append(contentsOf: bindableComponents)
        }
        
        if !bindableComponentsInSubView.isEmpty {
            fields = fields.filter {($0 is DataBindable)}
            fields.append(contentsOf: bindableComponentsInSubView as [AnyObject])
        }
        
        let fieldsSortered = fields.sorted { (parseField1, parseField2) -> Bool in
            if parseField1 is DataBindable && parseField2 is DataBindable {
                return (parseField1 as! DataBindable).fieldPath.components(separatedBy: ".").count < (parseField2 as! DataBindable).fieldPath.components(separatedBy: ".").count
            }else {
                return false
            }
        }
        
        fields = fieldsSortered
        isFieldSorted = true
    }
    
    private func extractValueAndUpdateComponent(object:[String:Any],component:UIView) {
        
        var valueIsPFObject = false
        
        for key in object.keys {
            valueIsPFObject = object[key] is [String:Any]
            if valueIsPFObject {
                let filtered = nextObjectQueue.filter {($0.keys.first! == key.capitalizeFirst)}
                if filtered.isEmpty {
                    let downMap = object[key] as! [String:Any]
                    nextObjectQueue.append([key:downMap])
                    extractValueAndUpdateComponent(object:downMap,component:component)
                }
                continue
            }
            if key == currentKeyPath.last {
                
                if let object = object[key] as? [String:Any] {
                    extractValueAndUpdateComponent(object: object, component: component)
                }else {
                    
                    var value = object[key]!
                    
                    if let label = component as? UILabel {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value as Any) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        label.text = String(describing: value)
                        self.delegate?.didFill(component: component, value: value as Any)
                    }else if let imageView = component as? UIImageView {
                        if verifyUrl(urlString: value as? String) {
                            
                            if let delegate = delegate {
                                if let newValue = delegate.willFill(component: component, value: value as Any) {
                                    value = newValue
                                }else {
                                    return
                                }
                            }
                            
                            if value is UIImage {
                                imageView.image = (value as! UIImage)
                                self.delegate?.didFill(component: component, value: imageView.image!)
                            }else if value is String {
                                imageView.kf.setImage(with: URL(string:(value as! String)), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                    self.delegate?.didFill(component: component, value: imageView.image ?? UIImage())
                                })
                            }
                            
                        }else {
                            print("field \(key) doesn't contains a valid URL")
                        }
                    }else if let textField = component as? UITextField {
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        textField.text = String(describing: value)
                        
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let textView = component as? UITextView {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        textView.text = value as! String
                        
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let slider = component as? UISlider {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        slider.value = value as! Float
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let uiSwitch = component as? UISwitch {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                        uiSwitch.isOn = value as! Bool
                        self.delegate?.didFill(component: component, value: value)
                        
                    }else if let _ = component as? UIScrollView {
                        
                        if let delegate = self.delegate {
                            if let newValue = delegate.willFill(component: component, value: value as Any) {
                                value = newValue
                            }else {
                                return
                            }
                        }
                        
                    }
                    
                    return
                }
            }
        }
    }
    
    public func fillFields(withObject object:[String:Any]) {
        self.fetchedObject = object
        sortFields()
        if let fields = fields , !fields.isEmpty {
            for field in fields {
                if let field = field as? DataBindable, field is UIView {
                    
                    if  !(field.fieldPath.count > 0) {
                        continue
                    }
                    
                    var keyPath = [String]()
                    var keyPathString = ""
                    for (index,path) in field.fieldPath.components(separatedBy: ".").enumerated() {
                        let path = path
                        if index == 0 {
                            continue
                        }
                        if index != field.fieldPath.components(separatedBy:".").count - 1 {
                            keyPathString = path
                        }
                        keyPath.append(path)
                    }
                    
                    //print(keyPath)
                    currentKeyPath = keyPath
                    
                    if nextObjectQueue.isEmpty {
                        nextObjectQueue.append(["":fetchedObject])
                    }
                    
                    if currentKeyPath.count == 1 {
                        extractValueAndUpdateComponent(object:self.fetchedObject, component: (field as! UIView))
                    }else {
                        
                        let filtered = nextObjectQueue.filter {($0.keys.first! == keyPathString.capitalizeFirst)}
                        if filtered.isEmpty {
                            extractValueAndUpdateComponent(object:self.fetchedObject, component: (field as! UIView))
                        }else {
                            extractValueAndUpdateComponent(object:filtered.first!.values.first!, component: (field as! UIView))
                        }
                    }
                }
            }
            self.delegate?.didFetch(error: nil)
        }
    }
    
    private func buildFieldAndValues() {
        self.sortFields()
        
        for field in self.fields {
            
            let fieldPath = (field as! DataBindable).fieldPath
            let fieldType = DataBindFieldType(rawValue: (field as! DataBindable).fieldType)
            
            var fieldValue:AnyObject!
            
            guard fieldPath.count > 0 else {
                print("fieldPath is nil")
                continue
            }
            
            guard fieldType != nil else {
                print("fieldType is nil")
                continue
            }
            
            if let textField = field as? DataBindable , textField is UITextField
                && textField.fieldPath.count > 0 {
                
                if ((textField as! UITextField).text!.count) > 0 {
                    fieldValue = (textField as! UITextField).text! as AnyObject!
                }else {
                    fieldValue = "" as AnyObject
                }
                
            }else if let textView = field as? DataBindable, textView is UITextView
                && textView.fieldPath.count > 0 {
                if ((textView as! UITextView).text!.count) > 0 {
                    fieldValue = (textView as! UITextView).text! as AnyObject!
                }else {
                    fieldValue = "" as AnyObject
                }
                
            }else if let imageView = field as? DataBindable, imageView is UIImageView
                && imageView.fieldPath.count > 0 {
                if (imageView as! UIImageView).image != nil {
                    fieldValue = (imageView as! UIImageView).image
                }else {
                    fieldValue = NSNull()
                }
                
            }else if let slider = field as? DataBindable, slider is UISlider
                && slider.fieldPath.count > 0 {
                if (slider as! UISlider).value != -1 {
                    fieldValue = (slider as! UISlider).value as AnyObject!
                }else {
                    fieldValue = NSNull()
                }
                
            }else if let uiSwitch = field as? DataBindable, uiSwitch is UISwitch
                && uiSwitch.fieldPath.count > 0 {
                fieldValue = (uiSwitch as! UISwitch).isOn as AnyObject!
                
            }else {
                continue
            }
            
            if let delegate = self.delegate {
                if let newValue = delegate.willSet(component: field, value: fieldValue) {
                    fieldValue = newValue as AnyObject
                }else {
                    continue
                }
            }
            
            guard (field as! DataBindable).persist == true else {
                print("\(field) is .persist false")
                continue
            }
            
            fieldValue = self.getObjectFieldValue(field:field, fieldValue: fieldValue, fieldType: fieldType!) as AnyObject!
            self.delegate?.didSet(component: field, value: fieldValue)
            
            self.fieldAndValues.append([fieldPath:fieldValue])
            
        }
    }
    
    public func toJSON() -> [String:Any] {
        self.buildFieldAndValues()
        
        guard !self.fieldAndValues.isEmpty else {
            print("There is no persist fields for save")
            return [:]
        }
        
        let _ = DataBindEntityBuilder(with: self.fieldAndValues)
        
        return (DataBindEntityBuilder.mainDictionary as! [String:Any]).values.first! as! [String:Any]
    }
    
    private func getObjectFieldValue(field:AnyObject,fieldValue:AnyObject,fieldType:DataBindFieldType) -> Any {
        
        var fieldValue = fieldValue
        
        if field is UISlider {
            return fieldValue
        }
        
        if !(fieldValue is NSNull) {
            switch fieldType {
            case .Number:
                if let stringValue = fieldValue as? String {
                    fieldValue = stringValue.replacingOccurrences(of: ",", with: ".") as AnyObject
                }
                fieldValue = fieldValue.doubleValue as AnyObject
                return fieldValue
            case .Logic:
                return fieldValue
            case .Image:
                return fieldValue
            default:
                return fieldValue
                
            }
        }
        return NSNull()
    }
 
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
}
