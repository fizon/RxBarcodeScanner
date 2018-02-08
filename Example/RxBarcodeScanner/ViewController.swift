//
//  ViewController.swift
//  RxBarcodeScanner
//
//  Created by Jeremy Boy on 01/04/2018.
//  Copyright (c) 2018 Jeremy Boy. All rights reserved.
//

import UIKit
import BarcodeScanner
import RxSwift
import RxCocoa
import RxBarcodeScanner

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create scanner in flatMap or keep instance as property
        // You can also use BarcodeScannerViewController.rx.createWith(navigationController:animated:configure:)
        // to push scanner on navigation stack
        let scanner = button.rx
            .tap
            .flatMapLatest { [weak self] _ -> Observable<BarcodeScannerViewController> in
                guard let _self = self else { return Observable.never() }
                return BarcodeScannerViewController.rx.createWith(parent: _self) { scanner in
                    // configure scanner
                    scanner.headerViewController.titleLabel.text = "RxBarcodeScanner"
                    scanner.headerViewController.closeButton.tintColor = .red
                }
            }
            .share(replay: 1)

        scanner
            .flatMapLatest { $0.rx.code }
            .subscribe(onNext: { [weak self] controller, barcode, type in
                self?.label.text = "Scanned \(type): \(barcode)"
                controller.dismiss(animated: true) {
                    controller.reset()
                }
            })
            .disposed(by: disposeBag)

        scanner
            .flatMapLatest { $0.rx.dismiss }
            .subscribe { event in
                switch event {
                case .next(let controller):
                    controller.dismiss(animated: true) {
                        controller.reset()
                    }
                case .completed:
                    print("Completed")
                case .error(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        scanner
            .flatMapLatest { $0.rx.error }
            .subscribe(onNext: { controller, error in
                controller.resetWithError(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

