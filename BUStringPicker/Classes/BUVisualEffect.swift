//
//  BUVisualEffect.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit

class BuVisualEffect : UIVisualEffectView {
  private var actionHandler: (() -> Void)?
  
  convenience init(_ alpha : CGFloat = 1, actionHandler: (() -> Void)?) {
    self.init(effect: UIBlurEffect(style: .dark))
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    self.alpha = alpha
    self.actionHandler = actionHandler
  }
  
  @objc func tap(sender: UIBarButtonItem) {
    actionHandler?()
  }
}
