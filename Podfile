# Uncomment the next line to define a global platform for your project
 platform :osx, '10.13'

target 'CopyCode' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
inhibit_all_warnings!
  # Pods for CopyCode
pod 'Bolts-Swift'
pod 'SwiftLint'
pod 'MASShortcut'
pod 'HockeySDK-Mac', '~> 5.1.0'
pod 'Mixpanel-swift'
pod 'FirebaseCore', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
pod 'FirebaseStorage', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
pod 'FirebaseDatabase', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
#pod 'FirebaseAuth', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'

  target 'CopyCodeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CopyCodeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
