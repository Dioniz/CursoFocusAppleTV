//
//  ParallaxButton.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 30/3/23.
//

import UIKit

class ParallaxButton: UIButton {

  override func awakeFromNib() {
    super.awakeFromNib()

    contentMode = .scaleToFill
    contentHorizontalAlignment = .fill
    contentVerticalAlignment   = .fill
    backgroundColor = .clear
    contentEdgeInsets = UIEdgeInsets.zero

    let richButton = RichButton(frame: self.frame)
      setImage(richButton.loadImageFromView(size: self.bounds.size), for: .normal)
    imageView?.adjustsImageWhenAncestorFocused = true
    imageView?.clipsToBounds = false
  }
}
