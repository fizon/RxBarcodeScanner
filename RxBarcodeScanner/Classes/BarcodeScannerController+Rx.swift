//
//  BarcodeScanner+Rx.swift
//  App
//
//  Created by jb on 03.01.18.
//  Copyright © 2018 FIZON GmbH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BarcodeScanner

public extension Reactive where Base: BarcodeScannerController {

    private var delegate: RxBarcodeScannerDelegateProxy {
        return RxBarcodeScannerDelegateProxy.proxy(for: base)
    }

    public var code: Observable<(BarcodeScannerController, String, String)> {
        return delegate.code
    }

    public var dismiss: Observable<BarcodeScannerController> {
        return delegate.dismiss
    }

    public var error: Observable<(BarcodeScannerController, Error)> {
        return delegate.error
    }
}
