//
//  UIScrollView+TopBottom.swift
//  ios-parallax-view
//
//  Created by Ben Deckys on 2021/10/14.
//

import UIKit

extension UIScrollView {
    var hasReachedTop: Bool {
        let insetTop: CGFloat
        insetTop = adjustedContentInset.top
        return contentOffset.y <= -insetTop
    }

    var hasReachedBottom: Bool {
        let insetBottom = adjustedContentInset.bottom
        return contentSize.height <= contentOffset.y + bounds.height - insetBottom + 0
    }
}
