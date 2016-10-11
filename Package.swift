import PackageDescription

let package = Package(
    name: "SFJSON",
    dependencies: [
		.Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 14, minor: 2)
	]
)
