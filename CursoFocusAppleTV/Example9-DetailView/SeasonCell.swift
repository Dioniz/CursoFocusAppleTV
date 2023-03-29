//
//  SeasonCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//


import UIKit

class SeasonCell: UICollectionViewCell {
    static let reuseIdentifer = "SeasonCell"

    var cellSelectedForInfo = false

    @IBOutlet weak var seasonLabel: UILabel!


    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        // Hack to change style when a season is selected
        if context.nextFocusedItem is UIButton {
            self.backgroundColor = .white
            self.seasonLabel.textColor = .black
            return
        }


        self.seasonLabel.textColor = .white

        if (isFocused) {
            self.backgroundColor = .orange
            self.seasonLabel.font = .systemFont(ofSize: 28)
        } else {
            self.backgroundColor = .gray
            self.seasonLabel.font = .systemFont(ofSize: 28)
        }
    }
}

class SeasonDummyCell: TrackCellDummy {
    static var reuseIdentifier = "SeasonDummyCell"
}

class SeasonDummyFocusableCell: TrackDummyFocusable {
    static var reuseIdentifier = "SeasonDummyFocusableCell"

}

class TrackCellDummy: UICollectionViewCell {
    override var canBecomeFocused: Bool {
        return false
    }
}

class TrackDummyFocusable: UICollectionViewCell {
    var focusable = true

    override var canBecomeFocused: Bool {
        return self.focusable
    }
}

class TrackCellMoreInfo: UICollectionViewCell {
    var focusable = true

    override var canBecomeFocused: Bool {
        return self.focusable
    }
}

protocol TrackViewCellMoreInfoDelegate: AnyObject {
    func cellMoreInfoLayoutUpdated()
}
