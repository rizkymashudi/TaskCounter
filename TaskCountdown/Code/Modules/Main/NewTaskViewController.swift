//
//  NewTaskViewController.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 18/10/21.
//

import Foundation
import UIKit

class NewTaskViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet weak var btnClose: UIButton!
  @IBOutlet weak var txtTaskName: UITextField!
  @IBOutlet weak var txtTaskDesc: UITextField!
  
  @IBOutlet weak var txtHours: UITextField!
  @IBOutlet weak var txtMinutes: UITextField!
  @IBOutlet weak var txtSeconds: UITextField!
  
  @IBOutlet weak var txtFieldContainerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var btnStart: UIButton!
  @IBOutlet weak var newTaskTopConstraint: NSLayoutConstraint!
  
  // MARK: - Variables
  private var taskViewModel: TaskViewModel!
  private var keyboardOpened = false
  
  // MARK: - lifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.taskViewModel = TaskViewModel()
    
    setupViews()
  }
  
  // MARK: - Setup views
  func setupViews(){
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.register(UINib(nibName: TaskTypesCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: TaskTypesCollectionViewCell.description())
    
    [self.txtHours, self.txtMinutes, self.txtSeconds].forEach {
      $0?.attributedPlaceholder = NSAttributedString(
        string: "00",
        attributes: [
          NSAttributedString.Key.font : UIFont(name: "Code-Pro-Bold-LC", size: 55)!,
          NSAttributedString.Key.foregroundColor : UIColor.label
        ])
      $0?.delegate = self
      $0?.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
    }
    
    self.txtTaskName.attributedPlaceholder = NSAttributedString(
      string: "Task name",
      attributes: [
        NSAttributedString.Key.font : UIFont(name: "Montserrat-Medium", size: 16.5)!,
        NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.55),
      ])
    self.txtTaskName.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
    
    self.txtTaskDesc.attributedPlaceholder = NSAttributedString(
      string: "Short description",
      attributes: [
        NSAttributedString.Key.font : UIFont(name: "Montserrat-Medium", size: 16.5)!,
        NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.55),
      ])
    self.txtTaskDesc.addTarget(self, action: #selector(self.textFieldInputChanged(_:)), for: .editingChanged)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
    tapGesture.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tapGesture)
    
    self.disabledButton()
    
    //Get value and set into label
    self.taskViewModel.getHours().bind { hours in
      self.txtHours.text = hours.appendZeroes()
    }
    
    self.taskViewModel.getMinutes().bind { minutes in
      self.txtMinutes.text = minutes.appendZeroes()
    }
    
    self.taskViewModel.getSeconds().bind { seconds in
      self.txtSeconds.text = seconds.appendZeroes()
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
    
  }
  
  // MARK: - Outlets & objc functions
  @IBAction func didTapStart(_ sender: UIButton) {
  }
  
  @IBAction func didTapClose(_ sender: UIButton) {
  }
  
  @objc func textFieldInputChanged(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    switch textField {
    case txtTaskName:
      self.taskViewModel.setTaskName(to: text)
    case txtTaskDesc:
      self.taskViewModel.setTaskDescription(to: text)
    case txtHours:
      guard let hours = Int(text) else { return }
      self.taskViewModel.setHours(to: hours)
    case txtMinutes:
      guard let minutes = Int(text) else { return }
      self.taskViewModel.setMinutes(to: minutes)
    case txtSeconds:
      guard let seconds = Int(text) else { return }
      self.taskViewModel.setSeconds(to: seconds)
    default:
      break
    }

    checkButtonStatus()
  }
  
  @objc func viewTapped(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if !Constants.hasTopNotch, !keyboardOpened {
      self.keyboardOpened.toggle()
      self.newTaskTopConstraint.constant -= self.view.frame.height * 0.2
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    self.newTaskTopConstraint.constant = 20
    self.keyboardOpened = false
    self.view.layoutIfNeeded()
  }
  
  // MARK: - Functions
  override class func description() -> String {
    return "NewTaskViewController"
  }
  
  func enableButton() {
    if self.btnStart.isUserInteractionEnabled == false {
      UIView.animate(
        withDuration: 0.25,
        delay: 0,
        options: .curveEaseOut) {
          self.btnStart.layer.opacity = 1
        } completion: { _ in
          self.btnStart.isUserInteractionEnabled.toggle()
        }
    }
  }
  
  func disabledButton() {
    if self.btnStart.isUserInteractionEnabled {
      UIView.animate(
        withDuration: 0.25,
        delay: 0,
        options: .curveEaseOut) {
          self.btnStart.layer.opacity = 0.25
        } completion: { _ in
          self.btnStart.isUserInteractionEnabled.toggle()
        }
    }
  }
  
  func checkButtonStatus() {
    if taskViewModel.isTaskValid() {
      enableButton()
    } else {
      disabledButton()
    }
  }
  
}

// MARK: - Extension
extension NewTaskViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 2
    let currentText: NSString = (textField.text ?? "") as NSString
    let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
    
    guard let text = textField.text else { return false }
    if text.count == 2 && text.starts(with: "0") {
      textField.text?.removeFirst()
      textField.text? += string
      self.textFieldInputChanged(textField)
    }
    
    return newString.length <= maxLength
  }
}

extension NewTaskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return taskViewModel.getTaskTypes().count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columns: CGFloat = 3.75
    let width: CGFloat = collectionView.frame.width
    let flowLayout = collectionViewLayout as!UICollectionViewFlowLayout
    let adjustedwidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
    
    return CGSize(width:adjustedwidth/columns,height:self.collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypesCollectionViewCell.description(), for: indexPath) as! TaskTypesCollectionViewCell
    cell.setupCell(taskType: self.taskViewModel.getTaskTypes()[indexPath.item], isSelected: taskViewModel.getSelectedIndex() == indexPath.item)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.taskViewModel.setSelectedIndex(to: indexPath.item)
    self.collectionView.reloadSections(IndexSet(0..<1))
    checkButtonStatus()
  }
}
