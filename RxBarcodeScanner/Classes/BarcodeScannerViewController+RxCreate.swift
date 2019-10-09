//
//  BarcodeScanner+Rx.swift
//  App
//
//  Created by jb on 03.01.18.
//  Copyright © 2018 FIZON GmbH. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import BarcodeScanner

public extension BarcodeScannerViewController {
    enum PresentationMode {
        case present
        case push
    }
}

public extension Reactive where Base: BarcodeScannerViewController {
    static func createWith(parent: UIViewController?, animated: Bool = true, configure: @escaping (BarcodeScannerViewController) throws -> () = { x in }) -> Observable<BarcodeScannerViewController> {
        return Observable.create { [weak parent] observer in
            let scanner = BarcodeScannerViewController()
            let dismissDisposable = scanner.rx
                .dismiss
                .subscribe(onNext: { [weak scanner] _ in
                    guard let scanner = scanner else {
                        return
                    }
                    dismissViewController(scanner, animated: animated)
                })

            do {
                try configure(scanner)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(scanner, animated: animated, completion: nil)
            observer.on(.next(scanner))

            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(scanner, animated: animated)
            })
        }
    }

    static func createWith(navigationController nc: UINavigationController, animated: Bool = true, configure: @escaping (BarcodeScannerViewController) throws -> () = { x in }) -> Observable<BarcodeScannerViewController> {
        return Observable.create { [weak nc] observer in
            let scanner = BarcodeScannerViewController()
            let dismissDisposable = scanner.rx
                .dismiss
                .subscribe(onNext: { [weak scanner] _ in
                    guard let scanner = scanner else {
                        return
                    }
                    guard let nc = nc, nc.topViewController == scanner else {
                        return
                    }
                    nc.popViewController(animated: animated)
                })

            do {
                try configure(scanner)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let nc = nc else {
                observer.on(.completed)
                return Disposables.create()
            }

            nc.pushViewController(scanner, animated: animated)
            observer.on(.next(scanner))

            return Disposables.create(dismissDisposable, Disposables.create { [weak nc] in 
                guard let nc = nc, nc.topViewController == scanner else { return }
                nc.popViewController(animated: animated)
            })
        }
    }
    
}

private func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}
