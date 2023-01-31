// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "RxBarcodeScanner",
	platforms: [
		.iOS(.v12)
	],
	products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "RxBarcodeScanner",
			targets: ["RxBarcodeScanner"]),
	],
	dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/fizon/BarcodeScanner.git", from: "5.0.4"), //Tag 5.0.4 //.revisionItem("6702c09f711840d031d29d92da50d935e8810ff9"
	],
	targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "RxBarcodeScanner",
			dependencies: ["BarcodeScanner", "RxSwift", .product(name: "RxCocoa", package: "RxSwift")],
            path: "Sources"),
	]
)
