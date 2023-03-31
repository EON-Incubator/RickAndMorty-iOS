//
//  BaseViewController.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-31.
//

import UIKit

class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
