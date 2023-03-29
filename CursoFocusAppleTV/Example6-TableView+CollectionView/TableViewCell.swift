//
//  TableViewCell.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 14/3/23.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func updateFocusIndex(tableIndex: Int, focusIndex: Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!

    static let cellHeight: CGFloat = 400
    static let cellSize = CGSize(width: 300, height: 308)
    static let cellFocusedSize = CGSize(width: 1160, height: 308)
    let images = ["movie-image-1", "movie-image-2", "movie-image-3"]

    var tableIndex: Int = 0
    var focusIndex: Int = 0
    var focusedIndexPath: IndexPath!
    var initialLoadToFirstCell = true
    var delegate: TableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.register(UINib(nibName: "ImageExpandableCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageExpandableCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createFlowLayout()
        collectionView.isScrollEnabled = false
    }

    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 34
        layout.minimumLineSpacing = 34
        return layout
    }

    func setData(tableIndex: Int, focusIndex: Int, delegate: TableViewCellDelegate) {
        self.tableIndex = tableIndex
        self.focusIndex = focusIndex
        self.delegate = delegate
    }

    func moveFocus(toIndex: Int) {
        if 0 <= toIndex && toIndex < 20 {
            self.focusedIndexPath = IndexPath(row: toIndex, section: 0)
            self.collectionView.setNeedsFocusUpdate()
        }
    }
}

// MARK: Data Source
extension TableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageExpandableCollectionCell", for: indexPath) as! ImageExpandableCollectionCell
        let mapPosition = ((indexPath.row + 1) % images.count)
        let image = UIImage(named: images[mapPosition])!
        cell.configure(delegate: self, index: indexPath.row, text: "T: \(self.tableIndex) C: \(indexPath.row)", image: image)
        return cell
    }
}

// MARK: Delegate
extension TableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) clicked")
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        focusedIndexPath
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: 200, height: TableViewCell.cellHeight)
        guard let cell = collectionView.cellForItem(at: indexPath) else {return TableViewCell.cellSize}

        if cell is ImageExpandableCollectionCell && (cell as! ImageExpandableCollectionCell).isOpen {
            return TableViewCell.cellFocusedSize
        } else {
            return TableViewCell.cellSize
        }
    }
}
//MARK: Focus
extension TableViewCell {

    override var canBecomeFocused: Bool {
        return false // To avoid conflict with the collectionView
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        // Si la siguiente vista enfocada es una celda de la colección
        if let focusView = context.nextFocusedView as? UICollectionViewCell,
           let indexPath = collectionView.indexPath(for: focusView) {

            // Si la celda de la tabla anterior y la siguiente son la misma (Seguimos en la misma fila)
            if context.nextFocusedView?.superview?.superview?.superview === context.previouslyFocusedView?.superview?.superview?.superview {
                // Actualizamos el índice seleccionado y notificamos mediante delegado
                self.focusIndex = indexPath.item
                self.delegate?.updateFocusIndex(tableIndex: self.tableIndex, focusIndex: self.focusIndex)

                coordinator.addCoordinatedAnimations({
                    let animated = ([UIFocusHeading.left, UIFocusHeading.right].contains(context.focusHeading)) ? true : false
                    self.collectionView.scrollToItem(at: IndexPath(item: self.focusIndex, section: 0), at: .left, animated: animated)
                })
            } else { // Cambiamos de fila
                // Actualizamos el foco de la nueva fila
                self.moveFocus(toIndex: self.focusIndex)
            }
        }
    }
}

//MARK: - ImageExpandableCollectionCell Delegate
extension TableViewCell : ImageExpandableCollectionCellDelegate {
    func cellLayoutUpdated() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.invalidateLayout()
    }


}
