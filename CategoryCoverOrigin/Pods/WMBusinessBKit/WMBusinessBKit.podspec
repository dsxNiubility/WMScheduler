#
#  Be sure to run `pod spec lint WMBusinessBKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#open working

Pod::Spec.new do |s|
  s.name         = "WMBusinessBKit"
  s.version      = "1.0.0"
  s.summary      = "WMBusinessBKit for test"
  s.homepage     = "nil"
  s.license      = "All rights reserved"
  s.author       = { "dongshangxian" => "dongshangxian@meituan.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "nil", :tag => "#{s.version}" }
  s.source_files  = "WMBusinessBKit", "Classes/**/*.{h,m}"
  s.resources = "Resources/*.png"
  s.preserve_paths = '*.pch'
  #s.prefix_header_file = 'WMBusinessBKit-prefix.pch'
  s.requires_arc = true

  s.dependency 'WMPlatformPKit','1.0.0'
end
