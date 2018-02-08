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

public extension Reactive where Base: BarcodeScannerViewController {

    private var delegate: RxBarcodeScannerDelegateProxy {
        return RxBarcodeScannerDelegateProxy.proxy(for: base)
    }

    public var code: Observable<(BarcodeScannerViewController, String, String)> {
        return delegate.code
    }

    public var dismiss: Observable<BarcodeScannerViewController> {
        return delegate.dismiss
    }

    public var error: Observable<(BarcodeScannerViewController, Error)> {
        return delegate.error
    }
}
