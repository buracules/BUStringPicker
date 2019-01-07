//
//  BUPickerView.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit


class BUPickerView : UIPickerView {
  
  var numberOfRowsInComponent : ((_ pickerView : UIPickerView, _ component: Int) -> Int)?
  
  var titlesForRow : ((_ pickerView : UIPickerView, _ row : Int, _ component : Int) -> String?)?
  
  var didSelectRow : ((_ pickerView : UIPickerView, _ row : Int, _ component : Int) -> ())?
  
  var viewForRow :((_ pickerView: UIPickerView, _ row: Int, _ component: Int, _ view: UIView?) -> UIView )?
  
  weak var parentView:BUStringPicker!
  
  convenience init(_ parent: BUStringPicker) {
    self.init(frame: .zero)
    self.parentView = parent
    delegate = self
    dataSource = self
    isAccessibilityElement = false
  }
  
}

extension BUPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return (self.numberOfRowsInComponent?(pickerView, component))!
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    return (self.viewForRow?(pickerView,row,component,view))!
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.didSelectRow?(pickerView, row, component)
  }
}

