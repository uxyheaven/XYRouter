Pod::Spec.new do |s|  
  version            = "0.6.3"
  s.name             = "XYRouter"  
  s.version          = version  
  s.summary          = "XYRouter是一个通过URL routing来解决UIViewController跳转依赖的类. "  
  s.homepage         = "https://github.com/uxyheaven"  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }  
  s.author           = { "uxyheaven" => "uxyheaven@163.com" }  
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/uxyheaven/XYRouter.git", :tag => version } 
  #s.source_files     = 'XYRouter/*'
  s.requires_arc     = true

  s.subspec 'XYRouter' do |ss|
    ss.source_files  = 'XYRouter/*'
  end

end