#
# Be sure to run `pod lib lint RMPScrollingMenuBarController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RMPScrollingMenuBarController"
  s.version          = "1.0.3"
  s.summary          = "A scrollable menu bar and multiple view controllers, which is managed like a UITabBarController."
  s.description      = <<-DESC
                      `RMPScrollingMenuBarController` has a scrollable menu bar, and multiple view controllers.

                      You can switch view controllers, which is managed like a `UITabBarController`, by swiping a screen or scrolling the menu.
                       DESC
  s.homepage         = "https://github.com/recruit-mp/RMPScrollingMenuBarController"
  s.screenshots      = "https://raw.githubusercontent.com/recruit-mp/RMPScrollingMenuBarController/master/docs/rmpscrollingmenubarcontroller.gif"
  s.license          = 'MIT'
  s.author           = { "kato" => "yoshihiro@sputnik-apps.com", "Recruit Marketing Partners Co.,Ltd." => "recruit_mp_oss@ml.cocorou.jp" }
  s.source           = { :git => "https://github.com/recruit-mp/RMPScrollingMenuBarController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'RMPScrollingMenuBarController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
