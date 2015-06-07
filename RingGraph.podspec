Pod::Spec.new do |s|
    s.name = 'RingGraph'
    s.version = '0.2.3'
    s.license = 'MIT'
    s.summary = 'Circular graph for attractive data presentation. Similar to AppleWatch fitness graphs.'
    s.homepage = 'https://github.com/yomajkel/RingGraph'
    s.social_media_url = 'https://twitter.com/michal_kreft'
    s.authors = { 'Michał Kreft' => 'kreft.michal@gmail.com' }
    s.source = { :git => 'https://github.com/yomajkel/RingGraph.git', :tag => s.version }
    s.ios.deployment_target = '8.0'
    s.source_files = 'RingGraph/RingGraph/*.swift'
    s.requires_arc = true
end
