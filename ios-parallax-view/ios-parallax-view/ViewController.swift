//
//  ViewController.swift
//  ios-parallax-view
//
//  Created by Ben Deckys on 2021/10/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var movingView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!

    lazy var range: Range<CGFloat> = {
        -movingView.bounds.height..<0
    }()

    var lastContentOffset = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 5000)
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.hasReachedTop && !scrollView.hasReachedBottom {
            let delta = scrollView.contentOffset.y - lastContentOffset
            if delta < 0 {
                // the value is negative, so we're scrolling up and the view is moving back into view.
                // take whatever is smaller, the constant minus delta, or the upperBound of the range. (0)
                topConstraint.constant = min(topConstraint.constant - delta, range.upperBound)
            } else {
                // the value is positive, so we're scrolling down and the view is moving out of sight.
                // take whatever is "larger," the constant minus delta, or the lowerBound of the range.
                topConstraint.constant = max(range.lowerBound, topConstraint.constant - delta)
            }
            // This makes the + or - number quite small.
            lastContentOffset = scrollView.contentOffset.y
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //
        // Where lastContentOffset is a class variable of type CGFloat
        //
        lastContentOffset = scrollView.contentOffset.y
    }
}

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
