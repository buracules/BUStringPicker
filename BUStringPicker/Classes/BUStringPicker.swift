//
//  BUStringPicker.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit

public class BUStringPicker : UIView {
  
  fileprivate struct Frames {
    private let sheetHeight:CGFloat = 300
    lazy var hidden:CGRect = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: sheetHeight)
    lazy var visible:CGRect = CGRect(x: 0, y: UIScreen.main.bounds.height - sheetHeight, width: UIScreen.main.bounds.width, height: sheetHeight)
  }
  
  public typealias doneBlock = ((_ selectedRow: Int, _ value: String)->())?
  public typealias cancelBlock = (()->())?
  
  var values:[String]!
  
  private var onSuccess: doneBlock
  private var onCancel: cancelBlock
  
  private lazy var visualEffectView = BuVisualEffect(0) {
    self.dismiss(nil)
  }
  
  public var sheetbackgroundColor : UIColor? {
    didSet{
      pickerBackView.backgroundColor = sheetbackgroundColor
      controlView.backgroundColor = sheetbackgroundColor
    }
  }
  
  public lazy var pickerView:AccesiblePickerView = {
    let pickerView = AccesiblePickerView(self)
    return pickerView
  }()
  
  public let toolbar = UIToolbar()
  
  internal var selectedIndex:Int!
  private let pickerBackView = UIView()
  private let controlView = UIView()
  
  public var isVisible:Bool = false
  private let controlsHeight:CGFloat = 40
  private var textFont:UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
  private var textAligment:NSTextAlignment = .center
  private var textColor:UIColor = .black
  private var frames = Frames()
  
  public init(_ title:String = "", values : [String], initialValue : Int = 0, onSuccess : doneBlock? = nil, onCancel : cancelBlock?) {
    super.init(frame: frames.hidden)
    accessibilityViewIsModal = true
    
    if let onSuccess = onSuccess {
      self.onSuccess = onSuccess
    }
    if let onCancel = onCancel {
      self.onCancel = onCancel
    }
    visualEffectView.frame = UIScreen.main.bounds
    self.values = values
    selectedIndex = initialValue
    setTitle(title)
    setBindings()
    configureViews()
    prepare()
    pickerView.picker.selectRow(initialValue, inComponent: 0, animated: false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var doneButton:UIBarButtonItem = {
    let button = UIButton()
    button.setTitle("Done", for: .normal)
    button.addTarget(self, action: #selector(onDoneClick), for: .touchUpInside)
    return UIBarButtonItem(customView: button)
  }()
  
  private let titleLabel:UIBarButtonItem = {
    let label = UILabel()
    label.text = ""
    return UIBarButtonItem(customView: label)
  }()
  
  private lazy var cancelButton:UIBarButtonItem = {
    let button = UIButton()
    button.setTitle("Cancel", for: .normal)
    button.setTitle("Cancel", for: .highlighted)
    button.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    return UIBarButtonItem(customView: button)
  }()
  

  
  private func configureViews() {
    sheetbackgroundColor = .white
    backgroundColor = .clear
    addSubview(pickerBackView)
    addSubview(controlView)
    pickerBackView.addSubview(pickerView)
    
    pickerBackView.translatesAutoresizingMaskIntoConstraints = false
    pickerBackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    pickerBackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    pickerBackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    pickerBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant : 10).isActive = true
    pickerBackView.clipsToBounds = true
    
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerView.leftAnchor.constraint(equalTo: pickerBackView.leftAnchor).isActive = true
    pickerView.topAnchor.constraint(equalTo: pickerBackView.topAnchor).isActive = true
    pickerView.rightAnchor.constraint(equalTo: pickerBackView.rightAnchor).isActive = true
    pickerView.bottomAnchor.constraint(equalTo: pickerBackView.bottomAnchor).isActive = true
    
    controlView.translatesAutoresizingMaskIntoConstraints = false
    controlView.heightAnchor.constraint(equalToConstant: controlsHeight).isActive = true
    controlView.leftAnchor.constraint(equalTo: pickerBackView.leftAnchor).isActive = true
    controlView.rightAnchor.constraint(equalTo: pickerBackView.rightAnchor).isActive = true
    controlView.topAnchor.constraint(equalTo: topAnchor, constant: -1 * (controlsHeight/2)).isActive = true
    
    
    let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let rightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    toolbar.setItems([cancelButton, leftSpace, titleLabel, rightSpace, doneButton], animated: false)
    toolbar.isUserInteractionEnabled = true
    toolbar.isAccessibilityElement = true
    controlView.addSubview(toolbar)
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    toolbar.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -10).isActive = true
    toolbar.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 10).isActive = true
    toolbar.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
    toolbar.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
    toolbar.isTranslucent = false
    
    controlView.layer.cornerRadius = 10
    if #available(iOS 11.0, *) {
      controlView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    } else {
      // Fallback on earlier versions
    }
    
    let seperatorView = UIView()
    controlView.addSubview(seperatorView)
    seperatorView.backgroundColor = .lightGray
    seperatorView.translatesAutoresizingMaskIntoConstraints = false
    seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    seperatorView.leftAnchor.constraint(equalTo: controlView.leftAnchor).isActive = true
    seperatorView.rightAnchor.constraint(equalTo: controlView.rightAnchor).isActive = true
    seperatorView.bottomAnchor.constraint(equalTo: controlView.bottomAnchor, constant: -0.5).isActive = true
    
    setAccesibility()
  }
  
  private func setAccesibility() {
    guard let titleLabel = titleLabel.customView as? UILabel,
      let cancelButton = cancelButton.customView as? UIButton,
      let doneButton = doneButton.customView as? UIButton else { return }
    if titleLabel.text == nil || titleLabel.text == "" {
      accessibilityElements = [cancelButton,doneButton,pickerView]
    } else {
      accessibilityElements = [cancelButton,titleLabel,doneButton,pickerView]
    }
    
    controlView.isAccessibilityElement = false
    pickerBackView.isAccessibilityElement = false
    isAccessibilityElement = false
    accessibilityViewIsModal = true
  }
  
  private func setBindings() {
    
    pickerView.picker.numberOfRowsInComponent = { picker , component in
      return self.values.count
    }
    
    pickerView.picker.viewForRow = {  picker, row, component, view in
      let label = UILabel()
      label.font = self.textFont
      label.text = self.values[row]
      label.textAlignment = self.textAligment
      label.textColor = self.textColor
      return label
    }
    
    pickerView.picker.didSelectRow = { picker, row , component in
      self.selectedIndex = row
    }
    
  }
  
  private func prepare() {
    if values.count > selectedIndex {
      self.pickerView.picker.selectRow(selectedIndex, inComponent: 0, animated: false)
    } else {
      fatalError("initial index out of bounds!")
    }
  }
  
  
  
  //MARK: - Controls
  @objc public func show() {
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self)
    UIApplication.shared.keyWindow?.addSubview(visualEffectView)
    UIApplication.shared.keyWindow?.addSubview(self)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
      self.frame = self.frames.visible
      self.visualEffectView.alpha = 0.75
    }) { (success) in
      self.isVisible = true
    }
  }
  
  @objc public func dismiss(_ onSuccess:(()->())?) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
      self.frame = self.frames.hidden
      self.visualEffectView.alpha = 0
    }) { (success) in
      self.isVisible = false
      self.removeFromSuperview()
      self.visualEffectView.removeFromSuperview()
      onSuccess?()
    }
  }
  
}

//Actions
extension BUStringPicker {
  @objc  func onDoneClick() {
    dismiss {
      self.onSuccess?(self.selectedIndex,self.values[self.selectedIndex])
    }
  }
  
  @objc func onCancelClick() {
    dismiss {
      self.onCancel?()
    }
  }
}

//Style Controls
public extension BUStringPicker {
  public func setTitle(font:UIFont? = nil) {
    if let titleLabel = titleLabel.customView as? UILabel{
      if let font = font {
        titleLabel.font = font
      }
    }
  }
  
  func setTitle(_ title : String? = nil) {
    if let titleLabel = titleLabel.customView as? UILabel{
      titleLabel.text = title
      titleLabel.accessibilityLabel = title
    }
  }
  
  public func setDoneButtonTitle(_ title: String, font:UIFont? = nil, textColor:UIColor = .black) {
    guard let button = doneButton.customView as? UIButton else { return }
    doneButton.isAccessibilityElement = false
    button.isAccessibilityElement = true
    button.accessibilityLabel = title
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    if let font = font {
      button.titleLabel?.font = font
    }
  }
  
  public func setCancelButtonTitle(_ title: String, font:UIFont? = nil, textColor:UIColor = .black) {
    guard let button = cancelButton.customView as? UIButton else { return }
    cancelButton.isAccessibilityElement = false
    button.isAccessibilityElement = true
    button.accessibilityLabel = title
    button.setTitle(title, for: .normal)
    button.setTitleColor(textColor, for: .normal)
    if let font = font {
      button.titleLabel?.font = font
    }
  }
  
  public func setPickerFont(_ font: UIFont? = nil, _ textColor: UIColor = .black, _ aligment: NSTextAlignment = .center) {
    if let font = font {
      self.textFont = font
    }
    self.textColor = textColor
    pickerView.picker.reloadAllComponents()
  }
  
  
}


