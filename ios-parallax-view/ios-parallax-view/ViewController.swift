//
//  ViewController.swift
//  ios-parallax-view
//
//  Created by Ben Deckys on 2021/10/14.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var movingView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!

    let viewModel = MainViewModel()
    var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 5000)

        viewModel
            .$scrollViewValue
            .sink { [weak self] value in
                self?.topConstraint.constant = value
            }
            .store(in: &cancellables)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel
            .apply(
                .scrollViewDidScroll(
                    .init(
                        contentOffsetY: scrollView.contentOffset.y,
                        topConstraintConstant: topConstraint.constant,
                        heightOfViewToMove: movingView.bounds.height,
                        hasReachedTop: scrollView.hasReachedTop,
                        hasReachedBottom: scrollView.hasReachedBottom
                    )
                )
            )
    }
}
