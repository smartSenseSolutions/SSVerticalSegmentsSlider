#
# Be sure to run `pod lib lint SSVerticalSegmentsSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SSVerticalSegmentsSlider'
    s.version          = '1.0.0'
    s.summary          = 'Multiple UI adaptable vertical segments slider'
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
    s.description      = <<-DESC
  TODO: Add long description of the pod here.
  It's a vertical segment slider developed in SwiftUI. It offers many properties to create different UI that fit your needs. We've listed down all properties 
  and usage explanations in our usage context. It is also called a sections slider.

                         DESC
  
    s.homepage         = 'https://github.com/smartSenseSolutions/SSVerticalSegmentsSlider'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'smartSense Solutions' => 'open-source@smartsensesolutoins.com' }
    s.source           = { :git => 'https://github.com/smartSenseSolutions/SSVerticalSegmentsSlider.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/smartsense13'
  
    s.ios.deployment_target = '14.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Sources/SSVerticalSegmentsSlider/**/*'
    
    # s.resource_bundles = {
    #   'SSVerticalSegmentsSlider' => ['SSVerticalSegmentsSlider/Assets/*.png']
    # }
  
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
  end
  
