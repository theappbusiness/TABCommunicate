#
# Be sure to run `pod lib lint TABCommunicate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TABCommunicate"
  s.version          = "0.1.4"
  s.summary          = "Send and recieve objects of a certain Type between devices"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        Uses mulitpeer connectivity to send an object back and forth between iOS and Mac devices.
                       DESC

  s.homepage         = "https://bitbucket.org/theappbusiness/tabcommunicate"
  s.license          = 'MIT'
  s.author           = { "Neil" => "neil.horton@theappbusiness.com" }
  s.source           = { :git => "git@bitbucket.org:theappbusiness/tabcommunicate.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TABCommunicate' => ['Pod/Assets/*.png']
  }
end
