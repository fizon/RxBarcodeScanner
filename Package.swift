// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RxBarcodeScanner",
	platforms: [
		.iOS(.v12)
	],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "RxBarcodeScanner",
			targets: ["RxBarcodeScanner"]),
	],
	dependencies: [
		.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
		.package(url: "https://github.com/fizon/BarcodeScanner.git", revision: "6702c09f711840d031d29d92da50d935e8810ff9") //Tag 5.0.4
	],
	targets: [
		.target(
			name: "RxBarcodeScanner",
			dependencies: ["BarcodeScanner", "RxCocoa", "RxSwift"],
			path: "RxBarcodeScanner"),
	]
)
