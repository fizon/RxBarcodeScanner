// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RxBarcodeScanner",
	platforms: [
		.iOS(.v10)
	],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "RxBarcodeScanner",
			targets: ["RxBarcodeScanner"]),
	],
	dependencies: [
		.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
		.package(url: "https://github.com/fizon/BarcodeScanner", .branch("master"))
	],
	targets: [
		.target(
			name: "RxBarcodeScanner",
			dependencies: ["BarcodeScanner", "RxCocoa", "RxSwift"],
			path: "RxBarcodeScanner"),
	]
)
