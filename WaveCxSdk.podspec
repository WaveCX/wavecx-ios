Pod::Spec.new do |s|
  s.name         = 'WaveCxSdk'
  s.version      = '0.1.0'
  s.summary      = 'WaveCX SDK for iOS'
  s.description  = 'WaveCX SDK for iOS. Supports iOS 15 and above.'
  s.homepage     = 'https://github.com/wavecx/wavecx-ios'
  s.license      = { :type => 'Apache 2.0', :file => "WaveCxSdk.xcframework/LICENSE" }
  s.author       = { 'Jonathan Raftery' => 'jonathan.raftery@wavecx.com' }

  s.platform     = :ios, '15.0'
  s.swift_version = '5.0'

  s.source       = {
    :http => 'https://github.com/WaveCX/wavecx-ios/releases/download/0.1.0/WaveCxSdk.xcframework.zip'
  }

  s.vendored_frameworks = 'WaveCxSdk.xcframework'
end
