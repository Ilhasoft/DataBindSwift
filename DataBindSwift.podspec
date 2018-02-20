#
# Be sure to run `pod lib lint DataBindSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DataBindSwift'
  s.version          = '0.1.0'
  s.summary          = 'DataBindSwift - Data x UI'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UI Components integrated with JSON.
                       DESC

  s.homepage         = 'https://github.com/daniel/DataBindSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daniel' => 'daniel@ilhasoft.com.br' }
  s.source           = { :git => 'https://github.com/daniel/DataBindSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DataBindSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DataBindSwift' => ['DataBindSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.dependency 'Kingfisher'

end
