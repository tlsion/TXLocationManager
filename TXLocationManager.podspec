
Pod::Spec.new do |s|

s.name         = "TXLocationManager"
s.version      = "1.0.0"
s.summary      = "a light weight and easy to use location manager."
s.homepage     = "https://github.com/tlsion/TXLocationManager"
s.license      = "MIT"
s.author       = { "Tlsion" => "249190182@qq.com" }
s.source       = { :git => "https://github.com/tlsion/TXLocationManager.git", :tag => s.version.to_s }
s.platform     = :ios, "5.0"
s.source_files  = "TXLocationManager/*"
s.frameworks = "UIKit", "CoreLocation"
s.requires_arc = true

end
