//
//  CustomTitleView.swift
//  musicnow
//
//  Created by QuyenDang on 19/02/2021.
//

import UIKit
protocol CustomTitleViewDelegate {
    func isExpandMenu(_ isExpand: Bool)
}
class CustomTitleView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var titleViewStack: UIStackView!
    
    var delegate: CustomTitleViewDelegate?
    var isExpand: Bool = false {
        didSet{
            let imageStr = isExpand ? "chevron.up": "chevron.down"
            self.actionImageView.image = UIImage(systemName: imageStr, withConfiguration: UIImage.SymbolConfiguration(scale: .small))
            let bgColor = isExpand ? UIColor.opaqueSeparator.withAlphaComponent(0.7) : UIColor.opaqueSeparator
            self.titleViewStack.backgroundColor = bgColor
            let font = UIFont.systemFont(ofSize: 18.0, weight: isExpand ? .regular : .medium)
            self.titleLabel.font = font
            self.animateArrow(toDown: !isExpand)
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    fileprivate func animateArrow(toDown: Bool) {
      let scale: CGFloat = toDown ? 1.0 : -1.0

      UIView.animate(
        withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
          self.actionButton.transform = CGAffineTransform(scaleX: 1.0, y: scale)
        },
        completion: nil
      )
    }
    
    class func instantiateFromNib() -> CustomTitleView {
        let nib = UINib(nibName: "CustomTitleView", bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        let customTitleView = nibObjects.first as! CustomTitleView
        return customTitleView
    }
    
    @IBAction func expand(_ sender: UIButton) {
        isExpand = !isExpand
        delegate?.isExpandMenu(isExpand)
    }
}
