//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

//MARK: TVGuideCellDelegate
protocol TVShowViewCellDelegate: class {
    func showInfo(tvGuide: ProgramVO)
//    func hideInfo()
    func rebind(indexPath: IndexPath, color: UIColor)
}

class TVShowViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var seassonRecordingLabel: UILabel!
    
    
    static let reuseIdentifier = "TVShowViewCell"

    
    var delegate: TVShowViewCellDelegate?
    
    var currentItem: Int!
    var currentTvguide: ProgramVO!
    var titleLabelTimer: Timer?
    var headerInitialDate: Date!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resumeScrollTitleLabel()
        self.recordingView.layer.cornerRadius = self.recordingView.frame.size.width / 2
    }
    
    func bind(indexPath: IndexPath, data: ProgramVO, smallCell: Bool, currentItem: Int, headerInitialDate: Date) {
        
        if data.hasAccess && data.ficha != nil {
            self.contentView.alpha = 1
        } else {
            self.contentView.alpha = 0.3
        }
        
        var xPoint = self.frame.width-70

        self.recordingView.isHidden = true
        self.seassonRecordingLabel.isHidden = true

        self.currentItem = currentItem

        if currentItem % 2 == 0 {
            self.rightView.backgroundColor = UIColor(red: 24, green: 28, blue: 29, alpha: 1)
            if self.frame.width > 60 {
                self.setGradientBackground(colorRight: .black, colorLeft: UIColor.black.withAlphaComponent(0.1), x: xPoint)
            }
        } else {
            self.rightView.backgroundColor = .black
            if self.frame.width > 60 {
                self.setGradientBackground(colorRight: UIColor(red: 24, green: 28, blue: 29, alpha: 1).withAlphaComponent(1), colorLeft: UIColor(red: 24, green: 28, blue: 29, alpha: 1).withAlphaComponent(0.1), x: xPoint)
            }
        }

        if UserDefaults.standard.object(forKey: K.headerInitialDate) == nil {
            UserDefaults.standard.set(headerInitialDate, forKey: K.headerInitialDate)
        }
        self.headerInitialDate = UserDefaults.standard.object(forKey: K.headerInitialDate) as? Date
        self.currentTvguide = data
        
        if smallCell {
            self.titleLabel.text = "*"
            self.titleLabel.textAlignment = .center
        } else {
            self.titleLabel.text = data.titulo
            self.titleLabel.textAlignment = .left
        }
        
        self.titleLabel.textColor = .init(named: "whiteAlpha70")
        
    }
    
    public func setTitleColor(color: UIColor) {
        if self.titleLabel.textColor != .init(named: "guideOrange") {
            self.titleLabel.textColor = color
        } else {
            self.titleLabel.textColor = .init(named: "guideOrange")
        }
    }
    
    
    func resetCell() {
        for layer: CALayer in self.layer.sublayers! {
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func setGradientBackground(colorRight: UIColor, colorLeft: UIColor, x: CGFloat) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorRight.cgColor, colorLeft.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: x, y: 4, width: 66, height: 112)

       layer.insertSublayer(gradientLayer, at: 10)
    }
    
    func configureSelectedCell() {

//        self.selectedItem = self.currentTvguide
        self.borderView.layer.borderWidth = 4.0
        self.borderView.layer.borderColor = (UIColor .init(named: "guideOrange"))?.cgColor
        self.layer.borderColor = (UIColor .init(named: "guideOrange"))?.cgColor
        self.titleLabel.textColor = .init(named: "guideOrange")
        self.titleLabelTimer?.invalidate()

        let iPath = IndexPath(item: self.currentItem, section: 0)
        self.delegate?.rebind(indexPath: iPath, color: UIColor.white)
        
    }
    
    func configureDeselectedCell() {
        
        self.borderView.layer.borderWidth = 0.0
        
        self.titleLabel.textColor = UIColor.lightGray
        self.resumeScrollTitleLabel()
        
        if self.currentItem > 0 {
            let iPath = IndexPath(item: self.currentItem-1, section: 0)
            self.delegate?.rebind(indexPath: iPath, color: .init(named: "whiteAlpha70") ?? .white)
        }
        
        let iPath = IndexPath(item: self.currentItem+1, section: 0)
        self.delegate?.rebind(indexPath: iPath, color: .init(named: "whiteAlpha70") ?? .white)
        
    }
     
    @objc private func resumeScrollTitleLabel() {

    }
 
}

extension TVShowViewCell {
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if(self.isFocused) {
            configureSelectedCell()
            self.delegate?.showInfo(tvGuide: self.currentTvguide)
        } else {
//            self.delegate?.hideInfo()
            configureDeselectedCell()
        }
    }
}
