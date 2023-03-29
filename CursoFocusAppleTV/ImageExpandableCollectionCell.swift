//
//  ImageExpandableCollectionCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 20/3/23.
//

import UIKit

protocol ImageExpandableCollectionCellDelegate: AnyObject {
    func cellLayoutUpdated()
}

class ImageExpandableCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!

    let focusedColor = UIColor(displayP3Red: 224/255, green: 169/255, blue: 0, alpha: 1)
    var index = 0
    var isOpen = false
    var delegate: ImageExpandableCollectionCellDelegate?
    var openTimer: Timer?

    func configure(delegate: ImageExpandableCollectionCellDelegate, index: Int, text: String, image: UIImage) {
        self.index = index
        self.delegate = delegate
        titleLabel.text = text
        movieImageView.image = image
    }

    func loadHomeBackground() {
        NotificationCenter.default.post(name: Example5View.loadHomeBackgroundImage, object: nil, userInfo: ["position": self.index])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.movieImageView.snp.remakeConstraints { make in
            make.width.equalTo(284)
        }
    }

    func startOpenTimer() {
        self.openTimer?.invalidate()
        self.openTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(openInfo), userInfo: nil, repeats: false)
        self.openTimer?.tolerance = 0.1
    }

    func stopOpenTimer() {
        self.openTimer?.invalidate()
    }

    @objc func openInfo () {
        self.isOpen = true
        self.setNeedsLayout()
        self.redrawCell()
        self.delegate?.cellLayoutUpdated()
    }

    func closeInfo() {
        self.isOpen = false
        self.setNeedsLayout()
        self.redrawCell()
        self.delegate?.cellLayoutUpdated()
    }

    func redrawCell() {
        if isOpen {
            UIView.animate(withDuration: 0.3) {
                self.infoStackView.isHidden = false
            }
        } else {
            self.infoStackView.isHidden = true
        }
    }
}

extension ImageExpandableCollectionCell {
    override var canBecomeFocused: Bool {
        return true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with withcoordinator: UIFocusAnimationCoordinator) {

        withcoordinator.addCoordinatedAnimations({ [unowned self] in
            if self.isFocused {
                //self.isOpen = true
                self.loadHomeBackground()
                self.titleLabel.textColor = focusedColor
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.movieImageView.layer.borderColor = focusedColor.cgColor
                self.movieImageView.layer.borderWidth = 5.0
                //self.infoStackView.isHidden = false
            }
            else {
                //self.isOpen = false
                self.stopOpenTimer()
                //self.closeInfo()
                self.titleLabel.textColor = .white
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.movieImageView.layer.borderColor = UIColor.clear.cgColor
                self.movieImageView.layer.borderWidth = 1.0
                //self.infoStackView.isHidden = true
            }
            /*self.layoutIfNeeded()
            self.setNeedsLayout()
            self.delegate?.cellLayoutUpdated()*/
        }, completion: nil)
    }
}
