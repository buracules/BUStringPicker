//
//  AccesiblePickerView.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 7.01.2019.
//

import UIKit

public class AccesiblePickerView : UIView {
  private weak var parent:BUStringPicker!
  
  var picker:BUPickerView!
  
  convenience init(_ parent: BUStringPicker) {
    self.init(frame: .zero)
    self.parent = parent
    isAccessibilityElement = true
    accessibilityTraits = super.accessibilityTraits | UIAccessibilityTraitAdjustable
    picker = BUPickerView(parent)
    addSubview(picker)
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    picker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    picker.topAnchor.constraint(equalTo: topAnchor).isActive = true
    picker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  override public func accessibilityActivate() -> Bool {
    if #available(iOS 10.0, *) {
      let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
      notificationFeedbackGenerator.notificationOccurred(.success)
    } else {
      // Fallback on earlier versions
    }
    
    parent.onDoneClick()
    return true
  }
  
  override public func accessibilityIncrement() {
    if parent.selectedIndex + 1 < parent.values.count {
      parent.selectedIndex = parent.selectedIndex + 1
      setAccesibilityText()
    }
  }
  
  override public func accessibilityDecrement() {
    if parent.selectedIndex - 1 >= 0 {
      parent.selectedIndex = parent.selectedIndex - 1
      setAccesibilityText()
    }
  }
  
  private func setAccesibilityText() {
    picker.selectRow(parent.selectedIndex, inComponent: 0, animated: true)
    //    accessibilityLabel = values[parent?.selectedIndex]
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, parent.values[parent.selectedIndex])
    if #available(iOS 10.0, *) {
      let hapticGenerator = UISelectionFeedbackGenerator()
      hapticGenerator.selectionChanged()
    }
    
  }
}
