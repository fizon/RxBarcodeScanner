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
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

        barcodeScanner.rx
            .error
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

