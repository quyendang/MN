//
//  NSMutableAttributedString.swift
//  musicnow
//
//  Created by Quyen on 10/7/20.
//

import Foundation
import UIKit

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
    func setHighlightColorForText(_ textToFind:String?,with color:UIColor){
        
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range!)
        }
    }
}
