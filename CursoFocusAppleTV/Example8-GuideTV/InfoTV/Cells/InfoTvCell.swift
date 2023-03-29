//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class InfoTvCell: UICollectionViewCell {
    
    static var reuseIdentifier = "InfoTvCell"
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }
    
    func prepareCell() {
        self.titleLabel.textColor = .blue
    }
    
    func bind(iconText: NSMutableAttributedString, titleString: String) {
        self.iconLabel.attributedText = iconText
        self.titleLabel.text = titleString
    }
    
}

extension InfoTvCell {
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if(self.isFocused) {
            self.titleLabel.isHidden = false
            self.iconLabel.textColor = .blue
        } else {
            self.titleLabel.isHidden = true
            self.iconLabel.textColor = .white
        }
        
    }

}
