#
#  Be sure to run `pod spec lint TXLocationManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "TXLocationManager"
s.version      = "1.0.0"
s.summary      = "A short description of TXLocationManager."
s.homepage     = "https://github.com/tlsion/TXLocationManager"
s.license      = "MIT"
s.author             = { "Tlsion" => "249190182@qq.com" }
s.source       = { :git => "https://github.com/tlsion/TXLocationManager.git", :tag => s.version.to_s }
s.platform     = :ios, "5.0"
s.source_files  = "TXLocationManager", "Classes/**/*.{h,m}"
s.frameworks = "UIKit", "CoreLocation"

end
