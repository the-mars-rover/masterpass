#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'masterpass'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for working with the masterpass in-app API.'
  s.description      = <<-DESC
A Flutter plugin for working with the masterpass in-app API.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'

  s.preserve_paths = 'MasterPassKit.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework MasterPassKit' }
  s.vendored_frameworks = 'MasterPassKit.framework'
end

