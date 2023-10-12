# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'
#

post_install do |installer_representation|
  installer_representation.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end

  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end

      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings["DEVELOPMENT_TEAM"] = "G38X79RVZ4"
      if config.name.include?("Debug")
        config.build_settings["OTHER_SWIFT_FLAGS"] ||= ['$(inherited)', '-DDEBUG']
      end
      next unless config.name == 'Release'
      config.build_settings['STRIP_INSTALLED_PRODUCT'] = 'YES'
    end
  end
end

target 'fitapp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fitapp
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod "RxGesture"
  pod 'Moya/RxSwift'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher'
  pod 'RxKingfisher'
  pod 'ModernAVPlayer'
  pod 'RxOptional'
  pod "RxGesture"
  pod 'lottie-ios', "3.5.0"
  pod 'RxReachability'
  pod 'Localize-Swift', '~> 2.0'
  pod 'KeychainAccess', '~> 4.1.0'
  pod "UPCarouselFlowLayout"
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'Firebase'
  pod 'GoogleSignIn', '~> 5.0'
  pod 'FBSDKLoginKit'
  pod 'FirebaseAppCheck'
  pod 'SwiftKeychainWrapper'
  pod 'JWTDecode', '~> 2.6'
  pod 'GoogleUtilities', '~> 7.11'
  pod 'FBSDKCoreKit'
  pod 'JTAppleCalendar', '~>  8.0.5'

  pod 'netfox'
  pod 'SkeletonView'
  pod 'ScrollableSegmentedControl'
  pod 'FYPhoto'

  #UI
  pod 'SnapKit', '5.0.1'
  pod 'PanModal', '1.2.7'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod "MBCircularProgressBar"
  pod 'ImageViewer.swift', '~> 3.0'

  target 'fitappTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'fitappUITests' do
    # Pods for testing
  end

end
