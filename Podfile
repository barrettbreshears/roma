# Uncomment the next line to define a global platform for your project
platform :ios, '14.1'

target 'mastodon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mastodon

pod 'SJFluidSegmentedControl'
pod 'PINRemoteImage'
pod 'Regift'
pod 'ReactiveSSE', '~> 0.3.0'
pod 'ReactiveSwift', '~> 4.0.0'
pod 'TinyConstraints'
pod 'StatusAlert', '~> 1.0.0'
pod 'NextLevel'
pod 'SAConfettiView'
pod 'Disk'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'SwiftyGiphy'
pod 'QuickLayout'
pod 'Firebase/Messaging'
pod 'Crashlytics'
pod 'Firebase/Core'
pod 'Fabric'
pod 'MessageKit', '~> 3.5.0'
pod 'TesseractOCRiOS'
pod 'CropViewController'
pod 'SwiftMessages'
pod 'DKImagePickerController'
pod 'MessageInputBar'
pod 'SKPhotoBrowser', '~> 6.1.0'
pod 'ActiveLabel'

end
# Update pods that have older deployment versions by default
post_install do |installer|
  # Targets:
  myTargets = ['DKImagePickerController']
  installer.pods_project.targets.each do |target|
    if myTargets.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
