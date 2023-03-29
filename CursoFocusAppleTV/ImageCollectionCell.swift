//
//  ImageCollectionCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 16/3/23.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var recordImageView: UIImageView!

    let focusedColor = UIColor(displayP3Red: 224/255, green: 169/255, blue: 0, alpha: 1)
    var index = 0

    func configure(index: Int, text: String, image: UIImage, isRecord: Bool? = false) {
        self.index = index
        titleLabel.text = text
        movieImageView.image = image
        recordImageView.isHidden = !(isRecord ?? false)
    }

    func loadHomeBackground() {
        NotificationCenter.default.post(name: Example5View.loadHomeBackgroundImage, object: nil, userInfo: ["position": self.index])
    }
}

extension ImageCollectionCell {
    override var canBecomeFocused: Bool {
        return true
    }

    // TODO: didUpdateFocus
    // Ejecución del didUpdateFocus dentro de una vista enfocable

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if self.isFocused {
            coordinator.addCoordinatedFocusingAnimations({ _ in
                self.setFocusState()
            })
        } else {
            coordinator.addCoordinatedUnfocusingAnimations({ _ in
                self.setUnFocusState()
            })
        }
    }

    func setFocusState() {
        self.loadHomeBackground()
        self.titleLabel.textColor = focusedColor
        self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        self.movieImageView.layer.borderColor = focusedColor.cgColor
        self.movieImageView.layer.borderWidth = 5.0
    }

    func setUnFocusState() {
        self.titleLabel.textColor = .white
        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.movieImageView.layer.borderColor = UIColor.clear.cgColor
        self.movieImageView.layer.borderWidth = 1.0
    }
}
