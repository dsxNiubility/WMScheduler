#
#  Be sure to run `pod spec lint WMBusinessAKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#open working

Pod::Spec.new do |s|
  s.name         = "WMBusinessAKit"
  s.version      = "1.0.0"
  s.summary      = "WMBusinessAKit for test"
  s.homepage     = "nil"
  s.license      = "All rights reserved"
  s.author       = { "dongshangxian" => "dongshangxian@meituan.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "nil", :tag => "#{s.version}" }
  s.source_files  = "WMBusinessAKit", "Classes/**/*.{h,m}"
  s.resources = "Resources/*.png"
  s.preserve_paths = '*.pch'
  #s.prefix_header_file = 'WMBusinessAKit-prefix.pch'
  s.requires_arc = true

  s.dependency 'WMPlatformPKit','1.0.0'
end
