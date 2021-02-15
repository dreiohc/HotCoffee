//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by Myron Dulay on 2/13/21.
//

import UIKit

protocol AddCoffeeOrderDelegate: class {
  func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
  func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController {
  
  weak var delegate: AddCoffeeOrderDelegate?
  
  private var vm = AddCoffeeOrderViewModel()
  private var coffeeSizesSegmentedControl = UISegmentedControl()
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nameTextField: UITextView!
  @IBOutlet weak var emailTextField: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  private func setupUI() {
    
    self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
    self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self.coffeeSizesSegmentedControl)
    self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20.0).isActive = true
    self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  }
  
  @IBAction func close() {
    if let delegate = self.delegate {
      delegate.addCoffeeOrderViewControllerDidClose(controller: self)
    }
  }
  
  
  @IBAction func save() {
    let name = self.nameTextField.text
    let email = self.emailTextField.text
    
    let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
    
    guard let indexPath = self.tableView.indexPathForSelectedRow else {
      fatalError("Error selecting coffee!")
    }
    
    self.vm.name = name
    self.vm.email = email
    
    self.vm.selectedSize = selectedSize
    self.vm.selectedType = self.vm.types[indexPath.row]
    
    WebService().load(resource: Order.create(vm: self.vm)) { result in
      switch result {
      case .success(let order):
        
        if let order = order, let delegate = self.delegate {
          DispatchQueue.main.async {
            delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
          }
        }
        
        
      case .failure(let error):
        print(error)
      }
    }
    
  }
  
  
}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.vm.types.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
    
    cell.textLabel?.text = self.vm.types[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }
}
