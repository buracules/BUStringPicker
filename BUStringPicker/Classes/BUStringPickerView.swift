//
//  BUStringPicker.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit

class BUStringPickerView : UIView {
  
  struct Frames {
    private let sheetHeight:CGFloat = 300
    lazy var hidden:CGRect = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: sheetHeight)
    lazy var visible:CGRect = CGRect(x: 0, y: UIScreen.main.bounds.height - sheetHeight, width: UIScreen.main.bounds.width, height: sheetHeight)
  }
  
  var values:[String]!
  
  var onDoneCalled:(()->(Bool))?
  var onCancelCalled:(()->())?
  
  public var sheetbackgroundColor : UIColor? {
    didSet{
      pickerBackView.backgroundColor = sheetbackgroundColor
      controlView.backgroundColor = sheetbackgroundColor
    }
  }
  
  let pickerContainer = AccesiblePickerContainer()
  
  var picker:BUPickerView {
    get {
      return pickerContainer.picker
    }
  }
  
  public let toolbar = UIToolbar()
  
  internal var selectedIndex:Int!
  private let pickerBackView = UIView()
  private let controlView = UIView()
  
  public var isVisible:Bool = false
  let controlsHeight:CGFloat = 40
  var textFont:UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
  var textAligment:NSTextAlignment = .center
  var textColor:UIColor = .black
  var frames = Frames()
  
  public init(_ title:String = "", values : [String], initialValue : Int = 0) {
    super.init(frame: frames.hidden)
    setTitle(title)
    self.values = values
    selectedIndex = initialValue
    setBindings()
    configureViews()
    
    pickerContainer.picker.selectRow(initialValue, inComponent: 0, animated: false)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var doneButton:UIBarButtonItem = {
    let button = UIButton()
    button.setTitle("Done", for: .normal)
    button.addTarget(self, action: #selector(onDoneClick), for: .touchUpInside)
    return UIBarButtonItem(customView: button)
  }()
  
  let titleLabel:UIBarButtonItem = {
    let label = UILabel()
    label.text = ""
    return UIBarButtonItem(customView: label)
  }()
  
  lazy var cancelButton:UIBarButtonItem = {
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
    pickerBackView.addSubview(pickerContainer)
    
    pickerBackView.translatesAutoresizingMaskIntoConstraints = false
    pickerBackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    pickerBackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    pickerBackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    pickerBackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant : 10).isActive = true
    pickerBackView.clipsToBounds = true
    
    pickerContainer.translatesAutoresizingMaskIntoConstraints = false
    pickerContainer.leftAnchor.constraint(equalTo: pickerBackView.leftAnchor).isActive = true
    pickerContainer.topAnchor.constraint(equalTo: pickerBackView.topAnchor).isActive = true
    pickerContainer.rightAnchor.constraint(equalTo: pickerBackView.rightAnchor).isActive = true
    pickerContainer.bottomAnchor.constraint(equalTo: pickerBackView.bottomAnchor).isActive = true
    
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
    
    prepare()
    setAccesibility()
  }
  
  func setTitle(_ title : String? = nil) {
    if let titleLabel = titleLabel.customView as? UILabel{
      titleLabel.text = title
      titleLabel.accessibilityLabel = title
    }
  }
  
   func setAccesibility() {
    guard let titleLabel = titleLabel.customView as? UILabel,
      let cancelButton = cancelButton.customView as? UIButton,
      let doneButton = doneButton.customView as? UIButton else { return }
    if titleLabel.text == nil || titleLabel.text == "" {
      accessibilityElements = [cancelButton,doneButton,pickerContainer]
    } else {
      accessibilityElements = [cancelButton,titleLabel,doneButton,pickerContainer]
    }
    
    controlView.isAccessibilityElement = false
    pickerBackView.isAccessibilityElement = false
    isAccessibilityElement = false
    accessibilityViewIsModal = true
  }
  
  private func setBindings() {
    
    pickerContainer.picker.numberOfComponentsIn = { picker in
      return 1
    }
    
    pickerContainer.picker.numberOfRowsInComponent = { picker , component in
      return self.values.count
    }
    
    pickerContainer.picker.viewForRow = {  picker, row, component, view in
      let label = UILabel()
      label.font = self.textFont
      label.text = self.values[row]
      label.textAlignment = self.textAligment
      label.textColor = self.textColor
      return label
    }
    
    pickerContainer.picker.didSelectRow = { picker, row , component in
      self.selectedIndex = row
    }
    setAccesibilityBindings()
  }
  
  private func prepare() {
    if values.count > selectedIndex {
      self.pickerContainer.picker.selectRow(selectedIndex, inComponent: 0, animated: false)
    } else {
      fatalError("initial index out of bounds!")
    }
  }
  
}

//Actions
extension BUStringPickerView {
  @discardableResult
  @objc  func onDoneClick() -> Bool {
    return onDoneCalled?() ?? true
  }
  
  @objc func onCancelClick() {
    onCancelCalled?()
  }
}



//Accesibility Controls
extension BUStringPickerView {
  private func setAccesibilityText() {
    pickerContainer.picker.selectRow(selectedIndex, inComponent: 0, animated: true)
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, values[selectedIndex])
    if #available(iOS 10.0, *) {
      let hapticGenerator = UISelectionFeedbackGenerator()
      hapticGenerator.selectionChanged()
    }
  }
  
  private func setAccesibilityBindings() {
    pickerContainer.accesibilityIncrement = {
      if self.selectedIndex + 1 < self.values.count {
        self.selectedIndex = self.selectedIndex + 1
        self.setAccesibilityText()
      }
    }
    
    pickerContainer.accesibilityDecrement = {
      if self.selectedIndex - 1 >= 0 {
        self.selectedIndex = self.selectedIndex - 1
        self.setAccesibilityText()
      }
    }
    
    pickerContainer.accesibilityActivate = {
      return self.onDoneClick()
    }
    
  }
}


