//
//  CursoAppleTV
//
//  Created by Fran Dioniz on 22/3/23.
//

import UIKit

class ChannelCellView: UICollectionViewCell {
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    var originalImageView: UIImageView!
    var processedImage: UIImage!
    
    static let reuseIdentifier = "ChannelCellView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.containerView.backgroundColor = .red
        prepareCell()
    }
    
    func prepareCell() {
        self.isUserInteractionEnabled = false
    }
    
    func bind(tvGuide: ProgramVO?, lastIndexPath: IndexPath, currentIndexPath: IndexPath) {
        
        if let currentTvGuide = tvGuide {
            if let dial = currentTvGuide.canal?.dial {
                self.numberLabel.text = "Canal \(dial)"
            }
            
            /*if lastIndexPath.item == currentIndexPath.item {
                if let image: Logo = currentTvGuide.canal?.logos?.filter({$0.id == "mux"}).first {
                    let imageURL = URL.create(string: image.uri!)
                    self.logoImageView.af_setImage(withURL: imageURL!)
                    self.numberLabel.alpha = 1
                }
            } else {
                if let image: Logo = currentTvGuide.canal?.logos?.filter({$0.id == "mux-epg-nofocus"}).first {
                    let imageURL = URL.create(string: image.uri!)
                    self.logoImageView.af_setImage(withURL: imageURL!)
                    self.numberLabel.alpha = 1
                }
            }*/
            
        }
    }
    
    func resetCell() {
        self.numberLabel.text = ""
    }

}

extension ChannelCellView {
    
    override var canBecomeFocused: Bool {
        return false
    }
    
}
