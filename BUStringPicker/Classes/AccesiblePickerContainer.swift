//
//  AccesiblePickerView.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 7.01.2019.
//

import UIKit

public class AccesiblePickerContainer : UIView {
  
  var accesibilityIncrement:(()->())?
  var accesibilityDecrement:(()->())?
  var accesibilityActivate:(()->(Bool))?
  
  var picker:BUPickerView = BUPickerView()
  
  convenience init() {
    self.init(frame: .zero)
    configureViews()
  }
  
  fileprivate func configureViews() {
    isAccessibilityElement = true
    accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitAdjustable
    addSubview(picker)
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    picker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    picker.topAnchor.constraint(equalTo: topAnchor).isActive = true
    picker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  override public func accessibilityActivate() -> Bool {
    return accesibilityActivate?() ?? true
  }
  
  override public func accessibilityIncrement() {
    accesibilityIncrement?()
  }
  
  override public func accessibilityDecrement() {
    accesibilityDecrement?()
  }
}
