//
//  ViewController.swift
//  BUStringPicker
//
//  Created by Burak Üstün on 8.06.2018.
//  Copyright © 2018 Team Buracules. All rights reserved.
//

import UIKit
import BUStringPicker

class ViewController: UIViewController {
  @IBOutlet weak var button: UIButton!{
    didSet{
      button.backgroundColor = .purple
      button.layer.cornerRadius = 10
      button.setTitleColor(.white, for: .normal)
      button.setTitle("Users Picker", for: .normal)
    }
  }
  
  let values = ["Mario Speedwagon", "Petey Cruiser", "Anna Sthesia","Paul Molive", "Anna Mull", "Gail Forcewind","Paige Turner", "Bob Frapples", "Walter Melon","Nick R. Bocker"]
  var picker:BUStringPickerController!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    picker = BUStringPickerController("Users", values: values, initialValue: 1, onSuccess: { (row, value) in
      print(value)
    }, onCancel: {
      print("canceled")
    })
    picker.setTitle(font: UIFont.boldSystemFont(ofSize: 15))
    picker.setPicker(UIFont.systemFont(ofSize: 12, weight: .bold))
    picker.setDoneButton("Tamam", font: UIFont.boldSystemFont(ofSize: 12))
    picker.setCancelButton("Vazgeç", font: UIFont.boldSystemFont(ofSize: 12))
    // Do any additional setup after loading the view, typically from a nib.
    
  }
  
  @IBAction func btnClick(_ sender: Any) {
    picker.show()
  }
  
}

