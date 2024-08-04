// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
        
        .library(
            name: "JobHuntAuthentication",
            targets: ["JobHuntAuthentication"]),
        
        .library(
            name: "JobHuntCore",
            targets: ["JobHuntCore"]),
        
        .library(
            name: "JobHuntLogin",
            targets: ["JobHuntLogin"]),
        
        .library(
            name: "JobHuntSettings",
            targets: ["JobHuntSettings"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
    ],
     
    targets: [
        
        .target(
            name: "DesignKit",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                "SnapKit"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        .target(
            name: "JobHuntAuthentication",
            dependencies: [
            .product(
                name: "FirebaseAuth",
                package: "firebase-ios-sdk"
            )
            ]
        ),
        
        .target(name: "JobHuntCore"),
        
        .target(
            name: "JobHuntLogin",
            dependencies: [
            "DesignKit",
            "JobHuntAuthentication",
            "JobHuntCore",
            "PhoneNumberKit",
            "SnapKit",
            "Swinject"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        .target(
            name: "JobHuntSettings",
            dependencies: [
            "DesignKit",
            "SnapKit",
            "SDWebImage",
            "Swinject",
            "JobHuntAuthentication",
            "JobHuntCore",
            .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
            .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
