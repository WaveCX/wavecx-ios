Pod::Spec.new do |s|
  s.name             = 'WaveCxSdk'
  s.version          = '1.0.0'
  s.summary          = 'Deliver targeted, contextual content to iOS users'

  s.description      = <<-DESC
    The WaveCx iOS SDK enables you to deliver targeted, contextual content
    to your users at precisely the right moments in their journey. Features
    include user session management, trigger point system, automatic and
    user-triggered content display, and comprehensive developer tools.
  DESC

  s.homepage         = 'https://github.com/wavecx/wavecx-ios'
  s.license          = { :type => 'Apache 2.0', :text => 'See LICENSE at https://github.com/WaveCX/wavecx-ios/blob/main/LICENSE' }
  s.author           = { 'WaveCx' => 'support@wavecx.com' }
  s.source           = {
    :http => 'https://github.com/wavecx/wavecx-ios/releases/download/v1.0.0/WaveCxSdk.xcframework.zip'
  }

  s.platform              = :ios, '15.6'
  s.swift_version         = '5.0'
  s.ios.deployment_target = '15.6'

  s.vendored_frameworks = 'WaveCxSdk.xcframework'

  s.frameworks = 'UIKit', 'WebKit'
end
