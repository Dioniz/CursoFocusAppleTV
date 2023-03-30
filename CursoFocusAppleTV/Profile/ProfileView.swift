//
//  ProfileView.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 28/3/23.
//

import UIKit

/// ProfileView show a list of user profiles and has the create and edit buttons.
class ProfileView: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileCollectionView: ProfileCollectionView!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var removedView: UIView!
    @IBOutlet var timerLabel: UILabel!

    var profileList: UserProfileList?
    var canPopView = true
    var onlySelectProfile = false
    var timerStopped = false
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        profileList = UserProfileList(maxNumProfiles: 6, currentProfile: 2, items: [
            UserProfile(id: "0", name: "Avatar 0"),
            UserProfile(id: "1", name: "Avatar 1"),
            UserProfile(id: "2", name: "Avatar 2")
        ])
        if let profileList = profileList {
            showProfileList(profileList: profileList)
        }
    }

    // MARK: Init
    func initView() {
        self.titleLabel.font = .systemFont(ofSize: 32)
        self.createButton.titleLabel?.font = .systemFont(ofSize: 30)
        self.editButton.titleLabel?.font = .systemFont(ofSize: 30)

        self.removedView.isHidden = true
        self.timerLabel.isHidden = true
    }

    func showProfileList(profileList: UserProfileList) {
        self.profileList = profileList
        self.profileCollectionView.initialize(profiles: profileList.items!, profileCellDelegate: self, preferredFocus: profileList.currentProfile ?? 0)

        if let numProfiles = profileList.items?.count {
            self.createButton.isEnabled = (numProfiles >= profileList.maxNumProfiles ?? 0) ? false : true
            self.editButton.isEnabled = numProfiles > 1
        }
    }

    func reloadProfiles(profileList: UserProfileList) {
        self.profileList = profileList

        if let numProfiles = profileList.items?.count {
            self.createButton.isEnabled = (numProfiles >= profileList.maxNumProfiles ?? 0) ? false : true
            self.editButton.isEnabled = numProfiles > 1
        }

        if let profiles = profileList.items {
            self.profileCollectionView.initialize(profiles: profiles, profileCellDelegate: self, preferredFocus: profileList.currentProfile ?? 0)
        }

        if onlySelectProfile && !timerStopped {
            self.timerLabel.isHidden = false
        }
    }

    // MARK: Others
    func selectProfileMode() {
        self.onlySelectProfile = true
        self.canPopView = false
    }

    func mainProfileDeleted() {
        self.canPopView = false
        self.removedView.isHidden = false
    }

    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }

    @IBAction func createButtonAction(_ sender: Any) {
        let count = profileList?.items?.count ?? 0
        profileList?.items?.append(UserProfile(id: "\(count)", name: "Avatar \(count)"))

        profileList?.currentProfile = count

        if let profileList = profileList {
            reloadProfiles(profileList: profileList)
        }
    }
}

extension ProfileView {

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        if let view = context.nextFocusedView as? ProfileCell,
           let index = profileCollectionView.indexPath(for: view) {
            self.profileList?.currentProfile = index.item - profileCollectionView.sideOffsetCount
        }
    }
}

extension ProfileView: ProfileCellDelegate {
    func onClickProfileCell(profile: UserProfile) {
        let count = profileList?.items?.count ?? 0
        profileList?.items?.append(UserProfile(id: "\(count)", name: "Avatar \(count)"))

        //profileList?.currentProfile = count

        if let profileList = profileList {
            reloadProfiles(profileList: profileList)
        }
    }

}
