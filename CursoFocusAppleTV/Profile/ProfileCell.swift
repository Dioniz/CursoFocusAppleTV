//
//  ProfileCell.swift
//  CursoFocusAppleTV
//
//  Created by Fran Dioniz on 28/3/23.
//

import UIKit

class ProfileCell: UICollectionViewCell {

    static let identifier = "Profile_Cell"

    var photoImageView = UIImageView()
    var imageView = UIImageView()
    var pickerBgImageView = UIImageView()
    var pickerBorderView = UIView()
    var editImageView = UIImageView()
    var titleLabel = UILabel()

    var text: String?
    var image: String?
    var editMode = false
    var imgPickerMode = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Background image. Used for blue border (selected)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(color: UIColor.clear, size: CGSize.init(width: 160, height: 160))
        imageView.layer.cornerRadius = 160/2
        imageView.clipsToBounds = true

        self.addSubview(imageView)

        imageView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(160)
        }

        // Profile image
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.image = UIImage.init(color: UIColor.clear, size: CGSize.init(width: 160, height: 174))
        photoImageView.layer.cornerRadius = 160/2
        photoImageView.clipsToBounds = true

        self.addSubview(photoImageView)

        photoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-17)
            make.right.left.equalToSuperview()
            make.height.equalTo(174)
        }

        // Profile name label
        titleLabel.font = .systemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .center

        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(text: String?, image: String?) {
        self.text = text
        self.image = image
        self.titleLabel.text = text
        if let image = image {
            self.photoImageView.image = .init(named: image)
        } else {
            self.photoImageView.image = nil
        }
    }

    func editMode(lock: Bool) {
        self.editMode = true
        // Foreground image. I's is used in edit mode
        editImageView.contentMode = .scaleAspectFit
        editImageView.image = UIImage.init(named: lock ? "lock" : "pencil")

        self.addSubview(editImageView)

        editImageView.snp.makeConstraints { (make) in
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.centerX.equalTo(self.imageView)
            make.centerY.equalTo(self.imageView)
        }
        self.photoImageView.alpha = 0.4
    }

    func imagePickerMode() {
        self.imgPickerMode = true

        // Background image for bottom-left small edit
        pickerBgImageView.layer.cornerRadius = 60/2
        pickerBgImageView.clipsToBounds = true
        pickerBgImageView.layer.borderWidth = 5.0
        pickerBgImageView.layer.borderColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 1).cgColor
        pickerBgImageView.backgroundColor = UIColor(displayP3Red: 28/255, green: 28/255, blue: 28/255, alpha: 0.95)

        // Border image for bottom-left small edit
        pickerBorderView.layer.cornerRadius = 50/2
        pickerBorderView.clipsToBounds = true
        pickerBorderView.layer.borderWidth = 2.0
        pickerBorderView.layer.borderColor = UIColor.white.cgColor

        // Bottom-left small image
        editImageView.image = UIImage.init(named: "pencil")
        editImageView.backgroundColor = .clear
        editImageView.contentMode = .scaleAspectFit

        self.addSubview(pickerBgImageView)
        self.addSubview(pickerBorderView)
        self.addSubview(editImageView)

        pickerBgImageView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.right.equalTo(self.imageView).offset(4)
            make.bottom.equalTo(self.imageView)
        }

        pickerBorderView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalTo(self.pickerBgImageView)
            make.centerY.equalTo(self.pickerBgImageView)
        }

        editImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerX.equalTo(self.pickerBgImageView)
            make.centerY.equalTo(self.pickerBgImageView)
        }

    }
}


//MARK: Focus
extension ProfileCell {

    override var canBecomeFocused: Bool {
        return true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        if context.previouslyFocusedView === self {
            // Unselected
            coordinator.addCoordinatedAnimations({
                self.titleLabel.textColor = UIColor.white
                self.imageView.layer.borderColor = UIColor.clear.cgColor
                self.imageView.layer.borderWidth = 1.0

                if self.editMode {
                    self.imageView.image = UIImage.init(color: UIColor.clear, size: CGSize.init(width: 160, height: 160))

                    if self.photoImageView != nil, let image = self.image {
                        self.photoImageView.alpha = 0.4
                        self.photoImageView.image = .init(named: "profile")
                    }
                }
                if self.imgPickerMode {
                    self.pickerBgImageView.backgroundColor = UIColor(displayP3Red: 28/255, green: 28/255, blue: 28/255, alpha: 0.95)
                    self.pickerBorderView.layer.borderColor = UIColor.white.cgColor
                }
            }, completion: nil)


            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        if context.nextFocusedView === self {
            // Selected
            coordinator.addCoordinatedAnimations({
                self.titleLabel.textColor = .orange
                self.imageView.layer.borderColor = UIColor.orange.cgColor
                self.imageView.layer.borderWidth = 5.0

                if self.editMode {
                    self.imageView.image = UIImage.init(color: .orange, size: CGSize.init(width: 160, height: 160))
                    if self.photoImageView != nil {
                        self.photoImageView.alpha = 1
                        self.photoImageView.image = nil
                    }
                }
                if self.imgPickerMode {
                    self.pickerBgImageView.backgroundColor = .orange
                    self.pickerBorderView.layer.borderColor = UIColor.clear.cgColor
                }
            }, completion: nil)

            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })

        }
    }
}
