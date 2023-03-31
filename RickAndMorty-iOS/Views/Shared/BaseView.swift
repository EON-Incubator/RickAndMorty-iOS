//
//  BaseView.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-31.
//

import UIKit

class BaseView: UIView {

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}
