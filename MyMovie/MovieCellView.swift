//
//  MovieCellView.swift
//  MyMovie
//
//  Created by Duc Dinh on 10/12/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class MovieCellView: UITableViewCell {
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: PaddingLabel!
  @IBOutlet weak var overviewLabel: PaddingLabel!
}

class PaddingLabel: UILabel {
  
  @IBInspectable var topInset: CGFloat = 5.0
  @IBInspectable var bottomInset: CGFloat = 5.0
  @IBInspectable var leftInset: CGFloat = 5.0
  @IBInspectable var rightInset: CGFloat = 30.0
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
  override var intrinsicContentSize: CGSize {
    get {
      var contentSize = super.intrinsicContentSize
      contentSize.height += topInset + bottomInset
      contentSize.width += leftInset + rightInset
      return contentSize
    }
  }
}
