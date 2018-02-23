platform :ios ,'8.0'

use_frameworks!

target 'testEventChain' do
#pod 'JSONModel', '~> 1.1.0'
#pod 'Masonry', '~> 0.6.2'
#pod 'ReactiveCocoa' , '~>2.4.7'
pod 'SDWebImage', '~> 3.7'
#pod 'MJRefresh',
pod 'YYModel'
#pod 'CTNetworking'
#pod 'YTKNetwork'
pod 'AFNetworking'
#pod 'Charts',:git => 'http://git.datayes.com/iOS-Library/DYCharts.git'
#pod 'Charts', :git => 'http://git.datayes.com/iOS-Library/DYCustomCharts.git'
pod 'YYCache'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '4.0'
		end
	end
end

