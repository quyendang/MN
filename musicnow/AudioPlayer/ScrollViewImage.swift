//
//  ScrollViewImage.swift
//  musicnow
//
//  Created by Quyen on 10/7/20.
//

import UIKit
import SnapKit

@IBDesignable
class ScrollViewImage: UIView {
    private(set) var scrollView = UIScrollView()
    private(set) var conorView = UIView()
    var imageView = UIImageView()
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    @IBInspectable var progress: Float = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.scrollView.setContentOffset(CGPoint(x: self.screenWidth * CGFloat(self.progress), y: 0), animated: true)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUIElement()
    }
    
    private func setupUI() {
        addSubView()
        constraintLayout()
    }
    
    private func addSubView(){
        conorView.addSubview(imageView)
        scrollView.addSubview(conorView)
        addSubview(scrollView)
    }
    
    private func constraintLayout(){
        
        
        scrollView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(conorView)
            make.leading.equalTo(conorView)
            make.trailing.equalTo(conorView)
            make.bottom.equalTo(conorView)
        }
    }
    
    
    private func configUIElement() {
        self.layoutIfNeeded()
        backgroundColor = .clear
        conorView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        conorView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = false
        scrollView.contentSize = CGSize(width: screenWidth * 2, height: frame.height)
        //scrollView.delegate = self
        scrollView.bounces = false
    }
    
    public func resetProgress(){
        self.progress = 0.0
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        conorView.frame = CGRect(x: 0, y: 0, width: screenWidth * 2, height: frame.height)
    }
}
//extension ScrollViewImage: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if isPlaying {
//            return
//        }
//
//        let offSet = scrollView.contentOffset
//        let progress = Float(offSet.x / screenWidth)
//        progressView.progress = progress
//        delegate?.onProgressChangingWith(progress)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offSet = scrollView.contentOffset
//        let progress: Float = Float(offSet.x / screenWidth)
//        UIView.animate(withDuration: 0.5, animations: {
//            self.progressView.frame.size.height = 5
//        }) { (completed) in
//            if completed {
//                self.delegate?.onProgressChangedWith(progress)
//                self.isPlaying = true
//            }
//        }
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        isPlaying = false
//        delegate?.onProgressStartChange(true)
//        UIView.animate(withDuration: 0.5) {
//           //self.progressView.barHeight = 10
//            self.progressView.frame.size.height = 10
//        }
//    }
//}
