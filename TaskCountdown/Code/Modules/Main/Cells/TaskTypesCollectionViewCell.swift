//
//  TaskTypesCollectionViewCell.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 19/05/22.
//

import UIKit

class TaskTypesCollectionViewCell: UICollectionViewCell {

  // MARK: - Outlets
  @IBOutlet weak var imgContainerView: UIView!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var lblTypeName: UILabel!
  
  
  // MARK: - Variables
  
  
  // MARK: - lifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    DispatchQueue.main.async {
      self.imgContainerView.layer.cornerRadius = self.imgContainerView.bounds.width / 2
    }
  }
  
  //MARK: - Setup views
  func setupCell(taskType: TaskType, isSelected: Bool){
    self.lblTypeName.text = taskType.typeName
    
    if isSelected {
      self.imgContainerView.backgroundColor = UIColor(hex: "17b890").withAlphaComponent(1)
      self.lblTypeName.textColor = UIColor(hex: "006666")
      self.imgView.tintColor = UIColor.white
      self.imgView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
    } else {
      self.imgView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
      reset()
    }
  }
  
  func reset() {
    
    self.imgContainerView.backgroundColor = UIColor.clear
    self.lblTypeName.textColor = UIColor.black
    self.imgView.tintColor = UIColor.black
  }
  
  // MARK: - Functions
  override class func description() -> String {
    return "TaskTypesCollectionViewCell"
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    reset()
    self.imgView.image = nil
  }
  
}
