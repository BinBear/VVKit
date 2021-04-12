#
# Be sure to run `pod lib lint VinBaseComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VinBaseComponents'
  s.version          = '0.1.1'
  s.summary          = '基础组件库'


  s.description      = <<-DESC
TODO: 基础组件库，包含网络请求，RAC组件，常用的Extentions
                       DESC

  s.homepage         = 'https://github.com/BinBear/VinBaseComponents'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BinBear' => 'vin404@outlook.com' }
  s.source           = { :git => 'https://github.com/BinBear/VinBaseComponents.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.subspec 'CocoaExtentions' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/CocoaExtentions/**/*'
  end

  s.subspec 'NetWorking' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/NetWorking/**/*'
    ss.dependency "AFNetworking"
    ss.dependency "YYCache"
    ss.dependency "CocoaLumberjack"
    ss.dependency 'VinBaseComponents/RACExtentions'
  end

  s.subspec 'RACExtentions' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/RACExtentions/**/*'
    ss.dependency "ReactiveObjC"
  end

  s.subspec 'StorageLib' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/StorageLib/**/*'
    ss.dependency 'Realm'
    ss.dependency 'UICKeyChainStore'
    ss.dependency 'MMKV'
  end

end
