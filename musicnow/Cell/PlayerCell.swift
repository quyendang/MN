//
//  PlayerCell.swift
//  musicnow
//
//  Created by Quyen on 10/5/20.
//

import UIKit
class PlayerCell: UICollectionViewCell {
    var isHide: Bool = true {
        didSet{
            DispatchQueue.main.async { [self] in
                self.progressView.isHidden = self.isHide
                self.progressLabel.isHidden = self.isHide
                self.totalTimeLabel.isHidden = self.isHide
                self.titleLabel.isHidden = self.isHide
                self.channelLabel.isHidden = self.isHide
                
            }
        }
    }
    
    var isPlaying: Bool = false {
        didSet {
            let imageStr = isPlaying ? "pause.fill": "play.fill"
            self.playButton.setImage(UIImage(systemName: imageStr, withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            let colorTitle = isPlaying ? progressView.tintColor.withAlphaComponent(0.85) : UIColor.clear
            let colorChannel = isPlaying ? UIColor.black.withAlphaComponent(0.85) : UIColor.clear
            let stringTitle = NSMutableAttributedString(string: self.titleLabel.text!)
            let stringChannel = NSMutableAttributedString(string: self.channelLabel.text!)
            stringTitle.setHighlightColorForText(self.titleLabel.text!, with: colorTitle)
            stringChannel.setHighlightColorForText(self.channelLabel.text!, with: colorChannel)
            titleLabel.attributedText = stringTitle
            channelLabel.attributedText = stringChannel
        }
    }
    
    var onPlayTapped : (() -> Void)? = nil
    var onAddTapped : (() -> Void)? = nil
    var onCommentTapped : (() -> Void)? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollImage: ScrollViewImage!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var channelLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func playTaped(_ sender: UIButton) {
        if let onPlayTapped = self.onPlayTapped{
            onPlayTapped()
        }
    }
    
    @IBAction func addTaped(_ sender: UIButton) {
        if let onAddTapped = self.onAddTapped{
            onAddTapped()
        }
    }
    
    @IBAction func nextTaped(_ sender: UIButton) {
        guard let current = PlayerManager.player.currentItemProgression else {return}
        PlayerManager.player.seek(to: current + 30)
    }
    
    @IBAction func commentTaped(_ sender: UIButton) {
        if let onCommentTapped = self.onCommentTapped{
            onCommentTapped()
        }
    }
}
