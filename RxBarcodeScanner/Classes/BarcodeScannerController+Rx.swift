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

    public var code: Observable<String> {
        return delegate.code
    }

    public var error: Observable<Error> {
        return delegate.error
    }
}
