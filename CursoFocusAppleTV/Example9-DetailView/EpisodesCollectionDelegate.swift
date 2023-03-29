//
//  EpisodesCollectionDelegate.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class EpisodesCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var episodes: [Episodio]!
    var indexForFirstNoDummyCell = 0
    var initialLoadToFirstCell = true
    var focusIndex = 0   // Last focused item for contents collection view

    var collectionView: UICollectionView!
    let images = ["movie-image-1", "movie-image-2", "movie-image-3"]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.episodes.count + 10
    }

    func setFocus(focusIndex: Int) {
        self.focusIndex = focusIndex
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ImageExpandableCollectionCell
        var cellDummyFocusable: TrackDummyFocusable
        var cellDummy: TrackCellDummy


        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageExpandableCollectionCell", for: indexPath) as! ImageExpandableCollectionCell

        cellDummyFocusable = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCellDummyFocusable", for: indexPath) as! TrackDummyFocusable
        cellDummyFocusable.focusable = false
        cellDummy = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCellDummy", for: indexPath) as! TrackCellDummy

        //Clear cell image to avoid show reused cell image
        //cell.resetCell()
        //cell.delegate = self

        if indexPath.item < self.episodes.count {
            let cellData = episodes[indexPath.item]

            let mapPosition = ((indexPath.row + 1) % images.count)
            let image = UIImage(named: images[mapPosition])!
            cell.configure(delegate: self, index: indexPath.row, text: "Episodio: \(indexPath.row)", image: image)

            /*if cellData.datosEditoriales?.subTipoContenido == "eventos"{
                // Send Contenido to cell instead Evento data type
                let newData = Contenido(JSONString: cellData.toJSONString()!)!
                cell.setContent(data: newData, trackType: .coleccion_horizontal, backgroundInteraction: false, expandableDescritpion: true)
            } else {
                cell.setContent(data: cellData, trackType: .coleccion_horizontal, backgroundInteraction: false, expandableDescritpion: true)
            }*/

            return cell

        } else {
            return cellDummy
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if initialLoadToFirstCell {
            let itemToFocus = (self.focusIndex == 0) ? self.indexForFirstNoDummyCell : self.focusIndex
            let indexToScroll = IndexPath(item: itemToFocus, section: 0)
            collectionView.scrollToItem(at: indexToScroll, at: .left, animated: false)
            initialLoadToFirstCell = false
        } else {
            if self.focusIndex != 0 {

                let indexToScroll = IndexPath(item: self.focusIndex, section: 0)

                if let selectedCell = collectionView.cellForItem(at: indexToScroll), !collectionView.visibleCells.contains(selectedCell){
                    UIView.animate(withDuration: 0.5) {
                        collectionView.scrollToItem(at: indexToScroll, at: .left, animated: false)
                    }
                }
            }
        }
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {

        let itemToFocus = (self.focusIndex == 0) ? self.indexForFirstNoDummyCell : self.focusIndex
        return IndexPath(item: itemToFocus, section: 0)

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension EpisodesCollectionDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return TableViewCell.cellSize}

        if cell is ImageExpandableCollectionCell && (cell as! ImageExpandableCollectionCell).isOpen {
            return TableViewCell.cellFocusedSize
        } else {
            return TableViewCell.cellSize
        }
    }
}

extension EpisodesCollectionDelegate: ImageExpandableCollectionCellDelegate {
    func cellLayoutUpdated() {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.invalidateLayout()
    }
}
