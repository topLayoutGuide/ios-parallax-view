//
//  ViewModel.swift
//  ios-parallax-view
//
//  Created by Ben Deckys on 2021/10/14.
//

import Foundation
import Combine

protocol ViewModel: ObservableObject {
    associatedtype Input: Equatable
    var cancellables: [AnyCancellable] { get }
    func apply(_ input: Input)
}
