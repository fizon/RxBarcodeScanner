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

    public var code: Observable<(ParentObject, String, String)> {
        return _code.asObservable()
    }

    public var error: Observable<(ParentObject, Error)> {
        return _error.asObservable()
    }

    public var dismiss: Observable<ParentObject> {
        return _dismiss.asObservable()
    }
}

open class RxBarcodeScannerDelegateProxy: DelegateProxy<BarcodeScannerController, BarcodeScannerDelegate>, DelegateProxyType {

    fileprivate let _code = PublishSubject<(ParentObject, String, String)>()
    fileprivate let _error = PublishSubject<(ParentObject, Error)>()
    fileprivate let _dismiss = PublishSubject<ParentObject>()

    public init(parentObject: ParentObject) {
        super.init(parentObject: parentObject, delegateProxy: RxBarcodeScannerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxBarcodeScannerDelegateProxy(parentObject: $0) }
    }
}

extension RxBarcodeScannerDelegateProxy: BarcodeScannerDelegate {
    public func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        _code.on(.next((controller, code, type)))
    }

    public func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        _error.on(.next((controller, error)))
    }

    public func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        _dismiss.on(.next(controller))
    }
}
