#
# Be sure to run `pod lib lint VinBaseComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VinBaseComponents'
  s.version          = '0.1.8'
  s.summary          = '基础组件库'


  s.description      = <<-DESC
TODO: 基础组件库
      BlockViewKit：UIScrollView、UITableView、UICollectionView基于Block的封装，支持链式调用，所有代理方法动态添加
      CocoaExtentions：常用的Extentions
      Components：常用的工具类
      NetWorking：基于AFNetWorking的网络请求组件，支持缓存，配置灵活
      RACExtentions：基于ReactCocoa封装的组件
      StorageLib：基于Realm数据库组件、基于MMKV的持久化组件
                       DESC

  s.homepage         = 'https://github.com/BinBear/VinBaseComponents'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BinBear' => 'vin404@outlook.com' }
  s.source           = { :git => 'https://github.com/BinBear/VinBaseComponents.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.subspec 'CocoaExtentions' do |ss|

    ss.source_files = 'VinBaseComponents/Classes/CocoaExtentions/CommonElement.h'

    ss.subspec 'Foundation' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/CocoaExtentions/Foundation/**/*'
    end

    ss.subspec 'UIKit' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/CocoaExtentions/UIKit/**/*'
    end

  end

  s.subspec 'Components' do |ss|

    ss.source_files = 'VinBaseComponents/Classes/Components/**/*'

  end

  s.subspec 'NetWorking' do |ss|

    ss.subspec 'TaskInfo' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/NetWorking/TaskInfo/**/*'
    end

    ss.subspec 'Cache' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/NetWorking/Cache/**/*'
      sss.dependency 'YYCache'
    end

    ss.subspec 'Base' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/NetWorking/Base/**/*'
      sss.dependency "AFNetworking"
      sss.dependency "CocoaLumberjack"
      sss.dependency "VinBaseComponents/NetWorking/TaskInfo"
      sss.dependency "VinBaseComponents/NetWorking/Cache"
      sss.dependency "VinBaseComponents/RACExtentions"
    end
    
  end

  s.subspec 'StorageLib' do |ss|

    ss.subspec 'MapKeyValueTool' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/StorageLib/MapKeyValueTool/**/*'
      sss.dependency 'MMKV'
      sss.dependency 'UICKeyChainStore'
    end

    ss.subspec 'RealmStore' do |sss|
      sss.source_files = 'VinBaseComponents/Classes/StorageLib/RealmStore/**/*'
      sss.dependency 'Realm'
    end

  end

  s.subspec 'RACExtentions' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/RACExtentions/**/*'
    ss.dependency "ReactiveObjC"
  end

  s.subspec 'BlockViewKit' do |ss|
    ss.source_files = 'VinBaseComponents/Classes/BlockViewKit/**/*'
    ss.dependency "VinBaseComponents/RACExtentions"
    ss.dependency "VinBaseComponents/Components"
  end

end
