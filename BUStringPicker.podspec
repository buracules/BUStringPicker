#
# Be sure to run `pod lib lint BUStringPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BUStringPicker'
  s.version          = '1.0.6'
  s.summary          = 'Accesible String Picker'
  s.homepage         = 'https://github.com/burakustn/BUStringPicker'
  s.screenshots      = 'https://burakustn.com/assets/images/BUStringPicker.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'burakustn' => 'burakustn@gmail.com' }
  s.source           = { :git => 'https://github.com/burakustn/BUStringPicker.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/burakustn'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4'
  s.source_files = 'BUStringPicker/Classes/*.swift'
end
