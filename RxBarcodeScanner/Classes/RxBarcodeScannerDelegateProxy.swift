//
//  RxBarcodeScannerDelegateProxy.swift
//  App
//
//  Created by jb on 03.01.18.
//  Copyright © 2018 FIZON GmbH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BarcodeScanner

extension BarcodeScannerController: HasDelegate {
    public var delegate: BarcodeScannerDelegate? {
        get {
            return codeDelegate as? BarcodeScannerDelegate
        }
        set(newValue) {
            codeDelegate = newValue
            errorDelegate = newValue
            dismissalDelegate = newValue
        }
    }
}

public protocol BarcodeScannerDelegate: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, NSObjectProtocol { }

extension RxBarcodeScannerDelegateProxy {

    public var code: Observable<String> {
        return _code.asObservable()
    }

    public var error: Observable<Error> {
        return _error.asObservable()
    }
}

open class RxBarcodeScannerDelegateProxy: DelegateProxy<BarcodeScannerController, BarcodeScannerDelegate>, DelegateProxyType {

    fileprivate let _code = PublishSubject<String>()
    fileprivate let _error = PublishSubject<Error>()

    public init(parentObject: ParentObject) {
        super.init(parentObject: parentObject, delegateProxy: RxBarcodeScannerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxBarcodeScannerDelegateProxy(parentObject: $0) }
    }
}

extension RxBarcodeScannerDelegateProxy: BarcodeScannerDelegate {
    public func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        _code.on(.next(code))
        controller.dismiss(animated: true) {
            controller.reset()
        }
    }

    public func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        _error.on(.next(error))
        controller.dismiss(animated: true) {
            controller.reset()
        }
    }

    public func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true) {
            controller.reset()
        }
    }
}
