//
//  MainViewModel.swift
//  ios-parallax-view
//
//  Created by Ben Deckys on 2021/10/14.
//

import UIKit
import Combine

class MainViewModel: ViewModel {

    // MARK: - Init
    // Any dependencies (services, properties et al) can be injected here

    init() {
        bind()
    }

    var cancellables: [AnyCancellable] = []

    // MARK: - Input

    let scrollViewDidScrollSubject = PassthroughSubject<Input.ScrollInfo, Never>()

    enum Input: Equatable {
        struct ScrollInfo: Equatable {
            var contentOffsetY: CGFloat
            var topConstraintConstant: CGFloat
            var heightOfViewToMove: CGFloat
            var hasReachedTop: Bool
            var hasReachedBottom: Bool
        }

        case scrollViewDidScroll(ScrollInfo)
    }

    func apply(_ input: Input) {
        switch input {
        case .scrollViewDidScroll(let info): scrollViewDidScrollSubject.send(info)
        }
    }

    // MARK: - Output
    @Published var scrollViewValue: CGFloat = 0

    // MARK: - Binding View Model
    private func bind() {
        scrollViewDidScrollSubject
            .scan(Optional<(Input.ScrollInfo?, Input.ScrollInfo)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
            .filter { $0?.hasReachedTop == false && $0?.hasReachedBottom == false && !$1.hasReachedTop && !$1.hasReachedBottom }
            .compactMap { previous, current -> CGFloat? in
                guard let previous = previous else { return nil }

                let minimumConstantValue = CGFloat(-current.heightOfViewToMove)
                let delta = current.contentOffsetY - previous.contentOffsetY
                if delta < 0 {
                  return min(current.topConstraintConstant - delta, 0)
                } else {
                  return max(minimumConstantValue, current.topConstraintConstant - delta)
                }
            }
            .assign(to: \.scrollViewValue, on: self)
            .store(in: &cancellables)
    }
}
