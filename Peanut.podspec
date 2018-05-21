Pod::Spec.new do |spec|
    spec.name = 'Peanut'
    spec.version    = '0.1.0'
    spec.summary    = 'A simple framework for accessing the pnut.io API.'
    spec.homepage   = 'https://github.com/shawnthroop/Peanut'
    spec.license    = { type: 'MIT', file: 'LICENSE' }

    spec.authors            = { 'Shawn Throop' => 'shawnthroop@gmail.com' }
    spec.social_media_url   = 'http://pnut.io/@shawn'

    spec.ios.deployment_target      = '11.0'
    spec.watchos.deployment_target  = '3.0'
    spec.tvos.deployment_target     = '11.0'

    spec.swift_version = '4.0'
    spec.requires_arc = true

    spec.source = { :git => 'https://github.com/shawnthroop/Peanut.git', :tag => spec.version }

    spec.source_files = 'Sources/**/*.{h,swift}'
end
