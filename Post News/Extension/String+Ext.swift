//
//  String+Ext.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

extension String {
    func calculateWidth(with height: CGFloat, font: UIFont) -> CGFloat {
        let rect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    func calculateHeight(with witdh: CGFloat, font: UIFont) -> CGFloat {
        let rect = CGSize(width: witdh, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
