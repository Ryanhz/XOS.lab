#
# Be sure to run `pod lib lint zymeWidget.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZymeWidget'
  s.version          = '0.1.0'
  s.summary          = 'A short description of zymeWidget.'
  s.swift_version = '5.0'
  s.module_name = 'Zyme'
  
  

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/1810022686@qq.com/ZymeWidget'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1810022686@qq.com' => '1810022686@qq.com' }
  s.source           = { :git => 'https://github.com/1810022686@qq.com/zymeWidget.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

# s.source_files = 'zymeWidget/Classes/**/*'
  
  s.subspec 'Base' do |base|
    base.source_files = 'ZymeWidget/Classes/Base/**/*'
    base.public_header_files = 'ZymeWidget/Classes/Base/**/*.h'
  end

  s.subspec 'UIWidget' do |widget|
    widget.source_files = 'ZymeWidget/Classes/UIWidget/**/*'
    widget.public_header_files = 'ZymeWidget/Classes/UIWidget/**/*.h'
    widget.dependency 'Kingfisher', '~> 5.7.0'
  end

  s.subspec 'Extension' do |extension|
    extension.source_files =  'ZymeWidget/Classes/base/**/*','ZymeWidget/Classes/Extension/**/*'
    extension.public_header_files = 'ZymeWidget/Classes/Extension/**/*.h'
    extension.dependency 'SnapKit', '~> 5.0.0'

  end
  s.subspec 'NetWorkEngine' do |networkEngine|
    networkEngine.source_files = 'ZymeWidget/Classes/base/**/*', 'ZymeWidget/Classes/extension/Foundation/String/StringExtension.swift', 'ZymeWidget/Classes/NetworkEngine/**/*'
    networkEngine.public_header_files = 'ZymeWidget/Classes/NetworkEngine/**/*.h'
    networkEngine.dependency 'HandyJSON', '~> 5.0.0'
    networkEngine.dependency 'Alamofire', '~> 4.8.2'
    networkEngine.dependency 'Cache'
  end
 



  # s.resource_bundles = {
  #   'zymeWidget' => ['zymeWidget/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
