//
//  LoadMoreReusableView.swift
//  musicnow
//
//  Created by Quyen on 10/8/20.
//

import UIKit

class LoadMoreReusableView: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
}
