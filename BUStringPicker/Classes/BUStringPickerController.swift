//
//  BUStringPickerController.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 9.01.2019.
//

import UIKit

public typealias doneBlock = ((_ selectedRow: Int, _ value: String)->())?
public typealias cancelBlock = (()->())?


public class BUStringPickerController: UIViewController {
  
  lazy var visualEffectView = BuVisualEffect(0) {
    self.dismissAnimation(nil)
  }
  
  var onSuccess: doneBlock
  var onCancel: cancelBlock
  var picker:BUStringPickerView!
  
  public convenience init(_ title:String = "", values : [String], initialValue : Int = 0, onSuccess : doneBlock? = nil, onCancel : cancelBlock?) {
    self.init()
    accessibilityViewIsModal = true
    view.isOpaque = false
    picker = BUStringPickerView(title, values: values, initialValue: initialValue)
    if let onSuccess = onSuccess {
      self.onSuccess = onSuccess
    }
    if let onCancel = onCancel {
      self.onCancel = onCancel
    }
    setBindings()
  }
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  public func show() {
    view.addSubview(visualEffectView)
    visualEffectView.frame = view.bounds
    view.addSubview(picker)
    modalPresentationStyle = .overCurrentContext
    picker.pickerContainer.accessibilityFrame = CGRect(x: 0, y: view.frame.height - picker.frames.visible.height + picker.controlsHeight/2, width: view.frame.width, height: picker.frames.visible.height - picker.controlsHeight/2)
    UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: false, completion: {
      self.showAnimation()
    })
  }
    
    @objc public func showAnimation() {
      UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, picker.pickerContainer)
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
        self.picker.frame = self.picker.frames.visible
        self.visualEffectView.alpha = 0.75
      }) { (success) in
      }
    }
    
    @objc public func dismissAnimation(_ onSuccess:(()->())?) {
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
        self.picker.frame = self.picker.frames.hidden
        self.visualEffectView.alpha = 0
      }) { (success) in
        self.dismiss(animated: false, completion: {
          onSuccess?()
        })
      }
  }
  
  func setBindings() {
    picker.onCancelCalled = {
      self.dismissAnimation({
        self.onCancel?()
        self.dismiss(animated: false, completion: nil)
      })
    }
    
    picker.onDoneCalled = {
      if #available(iOS 10.0, *) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.notificationOccurred(.success)
      }
      self.dismissAnimation {
        self.onSuccess?(self.picker.selectedIndex,self.picker.values[self.picker.selectedIndex])
      }
      return true
    }
  }
}

//Style Controls
public extension BUStringPickerController {
  public func setTitle(font:UIFont? = nil) {
    if let titleLabel = picker.titleLabel.customView as? UILabel{
      if let font = font {
        titleLabel.font = font
      }
    }
  }
  
  public func setDoneButton(_ title: String, font:UIFont? = nil, textColor:UIColor = .black) {
    guard let button = picker.doneButton.customView as? UIButton else { return }
    picker.doneButton.isAccessibilityElement = false
    button.isAccessibilityElement = true
    button.accessibilityLabel = title
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    if let font = font {
      button.titleLabel?.font = font
    }
  }
  
  public func setCancelButton(_ title: String, font:UIFont? = nil, textColor:UIColor = .black) {
    guard let button = picker.cancelButton.customView as? UIButton else { return }
    picker.cancelButton.isAccessibilityElement = false
    button.isAccessibilityElement = true
    button.accessibilityLabel = title
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    if let font = font {
      button.titleLabel?.font = font
    }
  }
  
  public func setPicker(_ font: UIFont? = nil, _ textColor: UIColor = .black, _ aligment: NSTextAlignment = .center) {
    if let font = font {
      picker.textFont = font
    }
    picker.textColor = textColor
    picker.picker.reloadAllComponents()
  }
  
  
}
