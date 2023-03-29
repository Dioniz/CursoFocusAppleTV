//
//  MainMenuItemCollectionViewCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 25/3/23.
//

import UIKit
import CoreText

protocol MainMenuItemCellDelegate: AnyObject {
    func menuCellLayoutUpdated()
}

class MainMenuItemCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "MainMenuItemCollectionViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!

    var currentDetailInfo: Bool = false

    weak var delegate: MainMenuItemCellDelegate?

    var opened: Bool = false
    var openTimer: Timer?

    override func awakeFromNib() {
        super.awakeFromNib()
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
        self.opened = true
        self.redrawCell()
    }

    func closeInfo() {
        self.stopOpenTimer()
        self.opened = false
        self.redrawCell()
        self.delegate?.menuCellLayoutUpdated()
    }

    func redrawCell() {
        guard let text = titleLabel.text else {
            return
        }

        if self.opened {
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.font = .systemFont(ofSize: 66)
                self.titleButton.titleLabel?.font = .systemFont(ofSize: 66)
                self.titleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

                self.titleLabel.textColor = .orange
                self.titleButton.setTitleColor(.orange, for: .normal)

                self.delegate?.menuCellLayoutUpdated()
                self.layoutIfNeeded()

            }
        } else {
            self.titleLabel.font = .systemFont(ofSize: 46)
            self.titleButton.titleLabel?.font = .systemFont(ofSize: 46)
            self.titleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)


            self.titleLabel.textColor = .white
            self.titleButton.setTitleColor(.white, for: .normal)
        }
    }

    override func layoutSubviews() {
    super.layoutSubviews()
        if !self.isFocused {
            self.redrawCell()
        }
    }

    func setData(menuItem: String) {
        titleLabel.text = menuItem
        titleButton.setTitle(menuItem, for: .normal)

        updateLabelAttributes()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        updateLabelAttributes()
    }

    func bind (title: String, detailInfo: Bool) {
        self.currentDetailInfo = detailInfo
        self.titleButton.setTitle(title, for: .normal)
    }

    fileprivate func updateLabelAttributes() {
        guard let text = titleLabel.text else {
            return
        }

        if self.isFocused {
            self.titleLabel.font = .systemFont(ofSize: 76)
            self.titleButton.titleLabel?.font = .systemFont(ofSize: 76)
            self.titleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

            self.titleLabel.textColor = .orange
            self.titleButton.setTitleColor(.orange, for: .normal)
        } else {
            self.titleLabel.font = .systemFont(ofSize: 46)
            self.titleButton.titleLabel?.font = .systemFont(ofSize: 46)
            self.titleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

            self.titleLabel.textColor = .white
            self.titleButton.setTitleColor(.white, for: .normal)
        }
    }

}

extension MainMenuItemCollectionViewCell {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.titleLabel.sizeToFit()

        if !self.isFocused {
            self.closeInfo()
        }
    }
}




