# BUStringPicker

[![CI Status](https://img.shields.io/travis/burakustn/BUStringPicker.svg?style=flat)](https://travis-ci.org/burakustn/BUStringPicker)
[![Version](https://img.shields.io/cocoapods/v/BUStringPicker.svg?style=flat)](https://cocoapods.org/pods/BUStringPicker)
[![License](https://img.shields.io/cocoapods/l/BUStringPicker.svg?style=flat)](https://cocoapods.org/pods/BUStringPicker)
[![Platform](https://img.shields.io/cocoapods/p/BUStringPicker.svg?style=flat)](https://cocoapods.org/pods/BUStringPicker)


<img src="https://burakustn.com/assets/images/BUStringPicker.png" alt="drawing" width="300"/>

## Usage
```swift
let picker = BUStringPicker("Users", values: values, initialValue: 1, onSuccess: { (row, value) in

}, onCancel: {

})
picker.show()
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

BUStringPicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BUStringPicker'
```
## Customization

You can customize the picker with the functions below
```swift
setTitle(font:UIFont? ) 
```
```swift
setDoneButtonTitle(_ title: String, font:UIFont?, textColor:UIColor) 
```
```swift
setCancelButtonTitle(_ title: String, font:UIFont?, textColor:UIColor ) 
```
```swift
setPickerFont(_ font: UIFont?, _ textColor: UIColor, _ aligment: NSTextAlignment) 
```

## Author

burakustn, burak.ustun@yga.org.tr

## License

BUStringPicker is available under the MIT license. See the LICENSE file for more info.
