# Uncomment the next line to define a global platform for your project
 platform :osx, '10.13'

target 'CopyCode' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
inhibit_all_warnings!

# Use the following line to use App Center Analytics and Crashes.
pod 'AppCenter'

# Use the following lines if you want to specify which service you want to use.
pod 'AppCenter/Analytics'
pod 'AppCenter/Crashes'
pod 'SwiftLint'
pod 'MASShortcut'
pod 'HockeySDK-Mac', '~> 5.1.0'
pod 'Mixpanel-swift'

  target 'CopyCodeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CopyCodeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
