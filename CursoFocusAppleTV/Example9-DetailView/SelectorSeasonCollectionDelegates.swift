//
//  SelectorSeasonCollectionDelegates.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class SelectorSeasonCollectionDelegates: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var seasons: [String]!
    var initialLoadToFirstCell = true
    var indexForFirstNoDummyCell = 0
    var focusIndexSelector = 0 // Last focused item for season selector UICollView

    var singleCellCollection: Bool {
        get { return seasons.count == 1}
    }

    func setInitialFocus(_ position: Int) {
        self.focusIndexSelector = position
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if singleCellCollection {
            return 1
        } else {
            return seasons.count + 15
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let lastContentCell = seasons.count

        if singleCellCollection {
            //let indice = indexPath.item
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.reuseIdentifer, for: indexPath) as! SeasonCell

            cell.seasonLabel.text = seasons[indexPath.item]
            cell.backgroundColor = .gray
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            cell.layoutIfNeeded()

            return cell

        } else {
                let lastItem = seasons.count
                if indexPath.item >= lastItem {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonDummyCell.reuseIdentifier, for: indexPath) as! SeasonDummyCell

                    return cell
                } else {
                    //let indice = indexPath.item
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.reuseIdentifer, for: indexPath) as! SeasonCell

                    cell.seasonLabel.text = seasons[indexPath.item]
                    cell.backgroundColor = .gray
                    cell.layer.cornerRadius = 4
                    cell.layer.masksToBounds = true
                    cell.layoutIfNeeded()

                    return cell
                }
        }
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return IndexPath(item: self.focusIndexSelector, section: 0)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if initialLoadToFirstCell {
            let itemToFocus = (self.focusIndexSelector == 0) ? self.indexForFirstNoDummyCell : self.focusIndexSelector
            let indexToScroll = IndexPath(item: itemToFocus, section: 0)
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexToScroll, at: .left, animated: false)
            }
            initialLoadToFirstCell = false
        } else {
            if self.focusIndexSelector != 0 {

                let indexToScroll = IndexPath(item: self.focusIndexSelector, section: 0)

                if let selectedCell = collectionView.cellForItem(at: indexToScroll), !collectionView.visibleCells.contains(selectedCell){
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5) {
                            collectionView.scrollToItem(at: indexToScroll, at: .left, animated: false)
                        }
                    }
                }
            }
        }
    }

}

extension SelectorSeasonCollectionDelegates: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.item >= 0 && indexPath.item < seasons.count {
            let thinFocusedFont: UIFont = .systemFont(ofSize: 35)
            let optionsForText = [NSAttributedString.Key.font : thinFocusedFont]
            let title = seasons[indexPath.item - indexForFirstNoDummyCell]
            let width = ceil(title.size(withAttributes: optionsForText).width) //+ 40
            if width > 237.0 {
                return CGSize(width: width, height: 64.0)
            } else {
                return CGSize(width: 237.0, height: 64.0)
            }
        } else {
            return CGSize(width: 237.0, height: 64.0)
        }

    }
}
