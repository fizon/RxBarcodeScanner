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

    private let barcodeScanner = BarcodeScannerController()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let barcodeScanner = self?.barcodeScanner else { return }
                self?.present(barcodeScanner, animated: true)
            })
            .disposed(by: disposeBag)

        barcodeScanner.rx
            .code
            .subscribe(onNext: { [weak self] controller, barcode, type in
                self?.label.text = "Scanned \(type): \(barcode)"
                controller.dismiss(animated: true) {
                    controller.reset()
                }
            })
            .disposed(by: disposeBag)

        barcodeScanner.rx
            .dismiss
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

        barcodeScanner.rx
            .error
            .subscribe(onNext: { controller, error in
                controller.resetWithError(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

