#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appscheme.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appscheme'
  s.version          = '1.0.3'
  s.summary          = 'iOS Universal Links and Custom URL schemes'
  s.description      = <<-DESC
  iOS Universal Links and Custom URL schemes.
                       DESC
  s.homepage         = 'http://scott-cry.win/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'my_snail@126.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
