#
#  Be sure to run `pod spec lint WMPlatformPKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#open working

Pod::Spec.new do |s|
  s.name         = "WMPlatformPKit"
  s.version      = "1.0.0"
  s.summary      = "WMPlatformPKit for test"
  s.homepage     = "nil"
  s.license      = "All rights reserved"
  s.author       = { "dongshangxian" => "dongshangxian@meituan.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "nil", :tag => "#{s.version}" }
  s.source_files  = "WMPlatformPKit","Classes/**/*.{h,m}"
  s.resources = "Resources/*.png"
  s.preserve_paths = '*.pch'
  #s.prefix_header_file = 'WMPlatformPKit-prefix.pch'
  s.requires_arc = true

end
