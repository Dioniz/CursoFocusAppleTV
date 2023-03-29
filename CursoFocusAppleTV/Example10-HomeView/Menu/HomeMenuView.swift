//
//  HomeMenuView.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 25/3/23.
//

import UIKit

protocol MenuViewDelegate: AnyObject {
    func menuItemSelected(index: Int)
}

class HomeMenuView: UIView {
    var collectionView: UICollectionView!
    var menuItems: [String] = []

    var scrollToBegginingOnce = true
    var infinitiveScrollIndexConstant = 10

    weak var delegate: MenuViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initMainMenuView(menuItems: [String]) {
        self.menuItems = menuItems

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 40.0
        layout.minimumLineSpacing = 40.0

        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: layout)

        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.remembersLastFocusedIndexPath = true
        self.collectionView.isScrollEnabled = false

        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 132, bottom: 0, right: 50)
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.clipsToBounds = true

        self.collectionView.register(UINib(nibName: MainMenuItemCollectionViewCell.reuseIdentifer, bundle: Bundle.main), forCellWithReuseIdentifier: MainMenuItemCollectionViewCell.reuseIdentifer)

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.addSubview(collectionView)
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [self.collectionView]
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if let focusView = context.nextFocusedView as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: focusView) {
            if focusView is MainMenuItemCollectionViewCell{
                (focusView as! MainMenuItemCollectionViewCell).startOpenTimer()
            }
            coordinator.addCoordinatedAnimations({
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }, completion: nil)
        }
    }
}

extension HomeMenuView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.menuItemSelected(index: indexPath.item % menuItems.count)
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return IndexPath(item: menuItems.count * infinitiveScrollIndexConstant, section: 0)
    }
}

extension HomeMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // High number of items to get more than max screen width
        return 1000
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMenuItemCollectionViewCell.reuseIdentifer,
                                                      for: indexPath) as! MainMenuItemCollectionViewCell

        cell.delegate = self
        cell.setData(menuItem: menuItems[indexPath.item % menuItems.count])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 0, scrollToBegginingOnce {
            let indexPath = IndexPath(item: menuItems.count * infinitiveScrollIndexConstant, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            scrollToBegginingOnce = false
        }
    }
}

extension HomeMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 150.0
        if let cell = collectionView.cellForItem(at: indexPath) {
            if  cell.isFocused {
                let name = menuItems[indexPath.item % menuItems.count]
                let thinFocusedFont = UIFont.systemFont(ofSize: 78)
                let optionsForText = [NSAttributedString.Key.font : thinFocusedFont]
                width = ceil(name.size(withAttributes: optionsForText).width)// + 15

                return CGSize(width: width, height: 90)
            } else {
                let item = menuItems[indexPath.item % menuItems.count]

                let thinFont = UIFont.systemFont(ofSize: 48)
                let optionsForText = [NSAttributedString.Key.font : thinFont]
                width = ceil(item.size(withAttributes: optionsForText).width) //+ 15

                return CGSize(width: width, height: 90)
            }
        } else {
            let item = menuItems[indexPath.item % menuItems.count]

            let thinFont = UIFont.systemFont(ofSize: 48)
            let optionsForText = [NSAttributedString.Key.font : thinFont]
            width = ceil(item.size(withAttributes: optionsForText).width) //+ 15

            return CGSize(width: width, height: 90)
        }
    }
}

//MARK: - MainMenuItemCell Delegate
extension HomeMenuView: MainMenuItemCellDelegate {
    func menuCellLayoutUpdated() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.invalidateLayout()
    }
}
