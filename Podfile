# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '10.0'
  use_frameworks!

  # play nicely with custom configurations
  project 'collection_view_demo'#, 'DebugMe' => :debug

  def shared_pods
    # A debug log framework for use in Swift projects.
    pod 'XCGLogger', '~> 7.0.0'

    # A software design pattern that implements Inversion of Control (IoC) for resolving dependencies.
    pod 'Swinject'

    # A collection of over 500 native Swift extensions.
    pod 'SwifterSwift'

    # A generic abstraction of computation expressed through Observable<Element> interface.
    pod 'RxSwift', '~> 4.5.0'
    pod 'RxCocoa', '~> 4.5.0'
    pod 'RxDataSources', '~> 3.0'
    pod 'RxFeedback', '~> 1.0'

    # A library that generates fake data.
    pod 'Fakery'

    # Netwroking
    pod 'Alamofire', '~> 5.0.0-beta.4'
  end

  # Pods for collection_view_demo
  target 'collection_view_demo' do
    shared_pods
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'XCGLogger'
         target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
         end
      end
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
           if config.name == 'Debug'
              config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
           end
        end
      end
    end
  end
