//
//  BUPickerView.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit


class BUPickerView : UIPickerView {
  
  //MARK: CallBacks
  var numberOfComponentsIn :((_ pickerView: UIPickerView) -> Int)?
  var numberOfRowsInComponent : ((_ pickerView : UIPickerView, _ component: Int) -> Int)?
  var titlesForRow : ((_ pickerView : UIPickerView, _ row : Int, _ component : Int) -> String?)?
  var didSelectRow : ((_ pickerView : UIPickerView, _ row : Int, _ component : Int) -> ())?
  var viewForRow :((_ pickerView: UIPickerView, _ row: Int, _ component: Int, _ view: UIView?) -> UIView )?
  
  convenience init() {
    self.init(frame: .zero)
    delegate = self
    dataSource = self
    isAccessibilityElement = false
  }
  
}

extension BUPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return numberOfComponentsIn?(pickerView) ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return numberOfRowsInComponent?(pickerView, component) ?? 0
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    return viewForRow?(pickerView,row,component,view) ?? UIView()
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    didSelectRow?(pickerView, row, component)
  }
}

