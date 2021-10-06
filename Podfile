project 'News.xcodeproj'
platform :ios, '10.0'
use_frameworks!

def network
  pod 'Moya', '~> 15.0'
end

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
end

def layout
  pod 'SnapKit'
end

def database
  pod 'RealmSwift'
end

def common_library
  network
  rx
  layout
  database
end

target "News" do
  common_library
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
            config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        end
    end
end

