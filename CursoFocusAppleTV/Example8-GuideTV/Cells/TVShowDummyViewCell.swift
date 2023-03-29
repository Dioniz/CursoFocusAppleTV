//
//  TVShowDummyViewCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit


class TVShowDummyViewCell: UICollectionViewCell {
 
    static let reuseIdentifier = "TVShowDummyViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }
    
    func prepareCell() {
    }
    
    func bind(currentItem: Int) {
        if currentItem % 2 == 0 {
            self.backgroundColor = .black
        } else {
            self.backgroundColor = UIColor(red: 24, green: 28, blue: 29, alpha: 1)
        }
    }
}

extension TVShowDummyViewCell {
    
    override var canBecomeFocused: Bool {
        return false
    }
    
}
