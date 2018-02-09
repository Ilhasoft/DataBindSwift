#
# Be sure to run `pod lib lint RestBind.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RestBind'
  s.version          = '0.1.0'
  s.summary          = 'RestBind makes rest API integration easy.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Make Rest integration easy.
                       DESC

  s.homepage         = 'https://github.com/daniel/RestBind'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daniel' => 'daniel@ilhasoft.com.br' }
  s.source           = { :git => 'https://github.com/daniel/RestBind.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RestBind/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RestBind' => ['RestBind/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'Alamofire'
   s.dependency 'ObjectMapper'
   s.dependency 'ISOnDemandTableView'
   s.dependency 'Kingfisher'

end
