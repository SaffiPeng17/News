project 'News.xcodeproj'
platform :ios, '10.0'
use_frameworks!

target "News" do
  pod 'SnapKit'
  pod 'Moya', '~> 15.0'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'Kingfisher'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
            config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        end
    end
end

