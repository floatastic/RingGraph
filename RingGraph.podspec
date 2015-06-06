Pod::Spec.new do |s|
    s.name = 'RingGrapg'
    s.version = '0.8.1'
    s.license = 'MIT'
    s.summary = 'CoreMotion Made insanely simple'
    s.homepage = 'https://github.com/MHaroonBaig/MotionKit'
    s.social_media_url = 'https://twitter.com/michal_kreft'
    s.authors = { 'Michał Kreft' => 'kreft.michal@gmail.com' }
    s.source = { :git => 'https://github.com/yomajkel/RingGraph.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.source_files = 'RingGraph/*.swift'
    s.requires_arc = true
end
