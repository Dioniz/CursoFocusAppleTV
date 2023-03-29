//
//  ProfileCollectionView.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 28/3/23.
//

import UIKit
protocol ProfileCellDelegate: AnyObject {
    func onClickProfileCell(profile: UserProfile)
}

class ProfileCollectionView: UICollectionView {

    var cellSize: CGSize = CGSize(width: 160, height: 200)
    var cellFocusedSize: CGSize = CGSize(width: 200, height: 200)

    var cellWidth = 160
    var cellSpacing = 20

    var sideOffsetCount = 5
    var preferredFocus: Int = 0

    var profileCellDelegate: ProfileCellDelegate?
    var profiles: [UserProfile] = []
    var isEditMode: Bool = false

    var scrollVisibles = false
    var createEditProfile = false

    func initialize(profiles: [UserProfile], isEditMode: Bool = false, scrollVisibles: Bool? = false, profileCellDelegate: ProfileCellDelegate, preferredFocus: Int? = 0) {

        func createFlowLayout() -> UICollectionViewFlowLayout {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 40
            return layout
        }

        func initializeProperties() {
            self.profiles = profiles
            self.isEditMode = isEditMode
            delegate = self
            dataSource = self

            self.reloadData()
        }

        func configureUI() {
            setCollectionViewLayout(createFlowLayout(), animated: false)
            backgroundColor = UIColor.clear
            translatesAutoresizingMaskIntoConstraints = false
            remembersLastFocusedIndexPath = true
            isScrollEnabled = false
            contentInsetAdjustmentBehavior = .never
            clipsToBounds = false
            register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
            register(CollectionGridCellDummy.self, forCellWithReuseIdentifier: "CollectionGridCellDummy")
        }

        self.profileCellDelegate = profileCellDelegate

        self.scrollVisibles = scrollVisibles!

        initializeProperties()
        configureUI()

        if self.scrollVisibles {
            self.sideOffsetCount = 0
        }

        self.preferredFocus = self.sideOffsetCount + (preferredFocus ?? 0)

        scrollToItem(at: IndexPath(row: self.preferredFocus, section: 0), at: .centeredHorizontally, animated: false)
    }

    func updateData(userProfiles: [UserProfile], isEditMode: Bool = false) {
        self.profiles = userProfiles
        self.isEditMode = isEditMode
        self.reloadData()
    }
}

//MARK: Table Data Source
extension ProfileCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sideOffsetCount + self.profiles.count + self.sideOffsetCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Profile_Cell", for: indexPath) as! ProfileCell
        let dummyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionGridCellDummy", for: indexPath) as! CollectionGridCellDummy

        if indexPath.item >= self.sideOffsetCount && indexPath.item < self.profiles.count + self.sideOffsetCount {

            let profile = self.profiles[indexPath.row - self.sideOffsetCount]
            cell.bind(text: self.createEditProfile ? "" : profile.name, image: "profile")
            print("\(indexPath.row) | \(indexPath.row - self.sideOffsetCount)")

            // Show lock icon
            if isEditMode {
                cell.editMode(lock: indexPath.item == self.sideOffsetCount)
            }

            // Image picker cell
            if indexPath.row == self.sideOffsetCount && self.createEditProfile {
                cell.imagePickerMode()
            }
            return cell
        } else {
            return dummyCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if scrollVisibles, let nextIndexPath = context.nextFocusedIndexPath {
            if nextIndexPath.row < (self.sideOffsetCount + self.profiles.count - 2) ||
                nextIndexPath.row > (self.sideOffsetCount + self.profiles.count + 2) {
                collectionView.scrollToItem(at: context.nextFocusedIndexPath!, at: .centeredHorizontally, animated: true)
            }
        } else if (context.nextFocusedIndexPath != nil) && !collectionView.isScrollEnabled {
            collectionView.scrollToItem(at: context.nextFocusedIndexPath!, at: .centeredHorizontally, animated: true)
        }
    }
}

//MARK: Table Delegate
extension ProfileCollectionView: UICollectionViewDelegate {

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
         return IndexPath(row: self.preferredFocus, section: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profilePosition = indexPath.row - self.sideOffsetCount
        if !(self.isEditMode && indexPath.row == self.sideOffsetCount),
            profilePosition >= 0, profiles.count > profilePosition {
            self.profileCellDelegate?.onClickProfileCell(profile: self.profiles[profilePosition])
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ProfileCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ProfileCollectionView {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        // Keep size as focused cell when focus leaves the collection
        if context.previouslyFocusedItem is UICollectionViewCell && !(context.nextFocusedItem is UICollectionViewCell) {
            let cell = context.previouslyFocusedItem as! UICollectionViewCell
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        }
    }
}


class CollectionGridCellDummy: UICollectionViewCell {
    override var canBecomeFocused: Bool {
        return false
    }
}
