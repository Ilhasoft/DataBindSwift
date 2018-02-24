**DataBindSwift**

With DataBindSwift you can map your components by their model structure.

### Supported Components:
- UITextField
- UITextView
- UIImageView
- UISlider
- UISwitch
- UILabel (Read Only)
- UIScrollView 
- UITableView



### Custom Components:

- You can implement DataBindable protocol to create your own component.
- All custom components need to subclass one of the supported components and implement DataBindable



### Requirements:

- iOS 9 +
- Swift 3



### Install with Cocoapods:

- pod 'DataBindSwift'



### How does it work? Interface Builder Step

- Add a UIView in your xib/story board and set that as DataBindView subclass.
- Add some components that implement DataBindable in that DataBindView.
- On the Attributes Inspector, fill: FieldType, FieldPath.
- After setting up the components, you need right click on your DataBindView and bind it with DataBindable components.
- Create an @IBoutlet to bind your DataBindView.



### How does it work in practice? Code Step

In some UIViewController, do:

1:

```swift
import DataBindSwift
```
2:

```swift
@IBOutlet var dataBindView:DataBindView!
```
3: Implement DataBindViewDelegate (Not mandatory).
>It's not mandatory, but if you need to intercept some methods of before or after processing, implement:

```swift
dataBindView.delegate = self

extension UIViewController : DataBindViewDelegate {
    func didFillAllComponents(JSON:[String:Any]) {
        
    }
    
    func willFill(component: Any, value: Any) -> Any? {
//        switch component as! UIView {
//        case self.someViewComponent:
//            break
//        default:
//            break
//        }
        return value
    }
    
    func didFill(component: Any, value: Any) {
        
    }
    
    func willSet(component: Any, value: Any) -> Any? {
        return value
    }
    
    func didSet(component: Any, value: Any) {
        
    }    
    
}
```
4 : 

```swift
self.dataBindView.toJSON()
```

5: I recommend use [ObjectMapper][https://github.com/Hearst-DD/ObjectMapper] to transform some model to JSON ([String:Any])

```swift
self.dataBindView.fillFields(withObject:someModel.toJSON())
// All bindable components in this moment will be filled automatically according by fieldPath
```

For Step 4 and 5 woks, you must did Interface Builder Step.



### DataBindable vars

Learn about how to use variables of DataBindable protocol works.

| Variable         | Type                                         | Description                                                  |
| ---------------- | -------------------------------------------- | ------------------------------------------------------------ |
| Required         | Bool (optional)                              | Fill component is mandatory                                  |
| Required Error   | String (optional)                            | Error message if component is not filled                     |
| Field Type       | String: 'Text', 'Number', 'Logic' or 'Image' | This is necessary for the algorithm to cast correctly for the corresponding field type. |
| Filed Type Error | String (optional)                            | Cast error message                                           |
| Field Path       | String                                       | Path of the field on your class structure, for example: 'vehicle.brand.car.model'. Vehicule will be your main entity, 'Brand' and 'Car' will be other two JSON object , and 'model' will be the field of 'Car' object. |
| Persist          | Bool                                         | If persist = false then this field will only use "read only" mode. |



> Developers can use optionals DataBindable vars to create your own field validator.
>
> FieldTypeError, Required and Required Error is not used in DataBindSwift algorithm. You can use as Helper to make your own validation rule.



### Class Structure 

- Sample of Input in Field Path: "vehicle.brand.car.model", will generate this class structure:

  ```markdown
  {
      vehicle = {
          brand = {
           	 car = {
              	     model: 
            	 }
          }
      }
  }
  ```

  - "model" value depends of its component's type. For example, if the component is a UITextField or a UITextView, the value will be a String. If the component is a UIImageView, however, the value will be a UIImage.

    ​
