#
# Be sure to run `pod lib lint EyuLibrary-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    #    s.use_frameworks!
    s.name             = 'EyuLibrary-ios'
    s.version          = '2.4.30'
    s.summary          = 'A short description of EyuLibrary-ios.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = 'EyuLibrary'
     
    s.homepage         = 'https://github.com/EyugameQy/EyuLibrary-ios'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'WeiqiangLuo' => 'weiqiangluo@qianyuan.tv' }
    s.source           = { :git => 'https://github.com/EyugameQy/EyuLibrary-ios.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    s.prefix_header_file = 'EyuLibrary-ios/Classes/PrefixHeader.pch'
    s.ios.deployment_target = '10.0'
    s.static_framework = true
    s.subspec 'Core' do |b|
        b.source_files = 'EyuLibrary-ios/Classes/**/*.{h,m,mm}'
        b.private_header_files = 'EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdSDK.framework/Headers/ABUAdapterRewardAdInfo.h'
        b.resource_bundle = { 'EyuLibrary' => 'EyuLibrary-ios/Classes/ad/view/*.xib'}
#        b.exclude_files = 'EyuLibrary-ios/Classes/framework/ABUAdSDK/**/*'
        b.dependency 'SVProgressHUD'
        b.dependency 'FFToast'
        # a.resource_bundles = {
        #   'BUAdSDK' => ['EyuLibrary-ios/Assets/BUAdSDK.bundle/*']
        #}
        
        #a.public_header_files = 'Pod/Classes/**/*.h'
        # a.frameworks = 'UIKit', 'MapKit'
        # a.dependency 'AFNetworking', '~> 2.3'
        b.frameworks = 'AdSupport','CoreData','SystemConfiguration','AVFoundation','CoreMedia'
        #      a.ios.libraries = 'c++','resolv.9'
    end
    
    # s.subspec 'gdt_action' do |gdt_action|
    #     gdt_action.vendored_frameworks = ['EyuLibrary-ios/3rd/GDTActionSDK.framework']
    #     gdt_action.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GDT_ACTION_ENABLED'}
    # end
    
    s.subspec 'um_sdk' do |um|
        um.dependency 'UMCCommon'
        um.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) UM_ENABLED'}
    end
    
    s.subspec 'af_sdk' do |af|
        af.dependency 'AppsFlyerFramework','6.2.5'
        af.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) AF_ENABLED'}
    end
    
    s.subspec 'iron_ads_sdk' do |iron_ads_sdk|
        iron_ads_sdk.dependency 'IronSourceSDK','7.0.3.0.0'
        iron_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) IRON_ADS_ENABLED'}
    end
    
    s.subspec 'admob_sdk' do |admob|
        admob.dependency 'Google-Mobile-Ads-SDK','8.9.0'
        admob.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_ADS_ENABLED'}
    end
    
    s.subspec 'fb_ads_sdk' do |fb_ads_sdk|
        fb_ads_sdk.dependency 'FBAudienceNetwork','6.5.1'
        fb_ads_sdk.dependency 'FBSDKCoreKit','11.1.0'
        fb_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FB_ADS_ENABLED FACEBOOK_ENABLED'}
    end
    
    # #新版本的FB广告sdk与白鹭引擎符号表冲突，需要使用此版本
    # s.subspec 'fb_ads_sdk_5_4_0' do |fb_ads_sdk_5_4_0|
    #     fb_ads_sdk_5_4_0.dependency 'FBAudienceNetwork','5.4.0'
    #     fb_ads_sdk_5_4_0.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FB_ADS_ENABLED FACEBOOK_ENABLED'}
    # end
    
    s.subspec 'applovin_ads_sdk' do |applovin_ads_sdk|
        applovin_ads_sdk.dependency 'AppLovinSDK','10.3.2'
        applovin_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) APPLOVIN_ADS_ENABLED'}
    end
    
    s.subspec 'applovin_max_sdk' do |applovin_max_sdk|
        applovin_max_sdk.dependency 'AppLovinSDK','11.5.0'
        applovin_max_sdk.dependency 'AppLovinMediationFacebookAdapter','6.5.1.0'
        applovin_max_sdk.dependency 'AppLovinMediationMintegralAdapter','7.2.6.0.1'
        applovin_max_sdk.dependency 'AppLovinMediationGoogleAdapter','8.9.0.0'
        applovin_max_sdk.dependency 'AppLovinMediationIronSourceAdapter','7.1.6.1.0'
        applovin_max_sdk.dependency 'AppLovinMediationByteDanceAdapter','4.6.2.2'
        applovin_max_sdk.dependency 'AppLovinMediationUnityAdsAdapter','3.7.5.0'
        applovin_max_sdk.dependency 'AppLovinMediationVungleAdapter','6.10.1.0'
        applovin_max_sdk.dependency 'AppLovinMediationFyberAdapter','7.8.3.2'
        applovin_max_sdk.dependency 'FBSDKCoreKit','11.1.0'
        applovin_max_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) APPLOVIN_MAX_ENABLED' }
    end
    
    s.subspec 'unity_ads_sdk' do |unity_ads_sdk|
        unity_ads_sdk.dependency 'UnityAds','3.6.0'
        unity_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) UNITY_ADS_ENABLED'}
    end
    
    s.subspec 'vungle_ads_sdk' do |vungle_ads_sdk|
        vungle_ads_sdk.dependency 'VungleSDK-iOS','6.9.2'
        vungle_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) VUNGLE_ADS_ENABLED'}
    end
    
    s.subspec 'bytedance_ads_cn_sdk' do |bytedance_ads_cn_sdk|
        bytedance_ads_cn_sdk.dependency 'Ads-CN', '3.9.0.4'
        bytedance_ads_cn_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) BYTE_DANCE_ADS_ENABLED'}
    end
    
    s.subspec 'bytedance_ads_global_sdk' do |bytedance_ads_global_sdk|
        bytedance_ads_global_sdk.dependency 'Ads-Global', '3.9.0.4'
        bytedance_ads_global_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) BYTE_DANCE_ADS_ENABLED'}
    end
    
    s.subspec 'mtg_ads_sdk' do |mtg_ads_sdk|
        mtg_ads_sdk.dependency 'MintegralAdSDK/InterstitialVideoAd','6.7.6.0'
        mtg_ads_sdk.dependency 'MintegralAdSDK/RewardVideoAd','6.7.6.0'
        mtg_ads_sdk.dependency 'MintegralAdSDK','6.7.6.0'
        mtg_ads_sdk.dependency 'MintegralAdSDK/BidNativeAd','6.7.6.0'
        mtg_ads_sdk.dependency 'MintegralAdSDK/InterstitialAd','6.7.6.0'
        mtg_ads_sdk.dependency 'MintegralAdSDK/BannerAd','6.7.6.0'
        mtg_ads_sdk.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MTG_ADS_ENABLED'}
    end
    
    s.subspec 'gdt_ads_sdk' do |gdt_ad|
        gdt_ad.dependency 'GDTMobSDK','4.12.3'
        gdt_ad.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GDT_ADS_ENABLED'}
    end
    
    s.subspec 'fb_login_sdk' do |fb|
        fb.dependency 'FBSDKCoreKit','11.1.0'
        fb.dependency 'FBSDKShareKit','11.1.0'
        fb.dependency 'FBSDKLoginKit','11.1.0'
        fb.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FACEBOOK_LOGIN_ENABLED FACEBOOK_ENABLED'}
    end
    
    s.subspec 'crashlytics_sdk' do |crash|
        crash.dependency 'Firebase/Crashlytics', '8.6.0'
    end
    
    s.subspec 'firebase_sdk' do |firebase|
        firebase.dependency 'Firebase/Analytics', '8.6.0'
        firebase.dependency 'Firebase/Core', '8.6.0'
        firebase.dependency 'Firebase/Messaging', '8.6.0'
        firebase.dependency 'Firebase/RemoteConfig', '8.6.0'
        firebase.dependency 'Firebase/Auth', '8.6.0'
        firebase.dependency 'Firebase/Firestore', '8.6.0'
        firebase.dependency 'Firebase/Storage', '8.6.0'
        firebase.dependency 'Firebase/DynamicLinks', '8.6.0'
#        firebase.dependency 'Firebase/AdMob', '7.8.0'
        firebase.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FIREBASE_ENABLED'}
    end
    
    s.subspec 'ReYunTracking' do |tracking|
        tracking.preserve_paths = 'EyuLibrary-ios/Classes/framework/ReYunTracking/Headers/*.h'
        tracking.vendored_libraries = 'EyuLibrary-ios/Classes/framework/ReYunTracking/libReYunTracking.a'
        tracking.libraries = 'ReYunTracking'
        tracking.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ReYunTracking/Headers/**",'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ReYunTracking/**" }
        tracking.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) TRACKING_ENABLED'}
        tracking.frameworks = 'iAd'
    end
    
    s.subspec 'gdt_action' do |gdt_action|
        gdt_action.preserve_paths = 'EyuLibrary-ios/Classes/framework/GDTActionSDK/Headers/*.h'
        gdt_action.vendored_libraries = 'EyuLibrary-ios/Classes/framework/GDTActionSDK/libGDTActionSDK.a'
        gdt_action.libraries = 'GDTActionSDK'
        gdt_action.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/GDTActionSDK/Headers/**",'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/GDTActionSDK/**" }
        gdt_action.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GDT_ACTION_ENABLED'}
    end
    
    s.subspec 'anythink_sdk' do |anythink|
#        anythink.vendored_frameworks = 'EyuLibrary-ios/Classes/framework/AnyThinkMTGAdapter/*.framework'
        anythink.dependency 'AnyThinkiOS', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkPangleAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkMintegralAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkGDTAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkAdmobAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkSigmobAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkUnityAdsAdapter', '5.7.77'
        anythink.dependency 'AnyThinkiOS/AnyThinkVungleAdapter', '5.7.77'
        anythink.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ANYTHINK_ENABLED'}
    end
    
    s.subspec 'admob_mediation_sdk' do |admob_mediation|
        admob_mediation.dependency 'Google-Mobile-Ads-SDK','8.2.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationAppLovin', '10.0.1.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationFacebook', '6.3.0.0'
        admob_mediation.dependency 'FBSDKCoreKit','9.1.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationFyber', '7.8.2.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationIronSource', '7.1.3.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationUnity', '3.6.0.0'
        admob_mediation.dependency 'GoogleMobileAdsMediationVungle', '6.9.1.0'
        admob_mediation.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_MEDIATION_ENABLED ADMOB_ADS_ENABLED'}
    end
    
    s.subspec 'tradplus_sdk' do |tradplus|
        tradplus.dependency 'TradPlusSDK', '5.0.2'
        tradplus.dependency 'TradPlusSDK/FacebookAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/AdMobAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/UnityAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/ApplovinAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/GDTMobAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/PangleAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/VungleAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/IronSourceAdapter', '5.0.2'
        tradplus.dependency 'TradPlusSDK/SigmobAdapter', '5.0.2'
        tradplus.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) TRADPLUS_ENABLED'}
    end
    
    s.subspec 'sigmob_ads_sdk' do |sigmob|
        sigmob.dependency 'SigmobAd-iOS', '2.24.1'
    end
    
    s.subspec 'thinking_sdk' do |thinking|
        thinking.dependency 'ThinkingSDK', '2.8.3.2'
        thinking.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) THINKING_ENABLED'}
    end
    
    s.subspec 'abu_ad_sdk' do |abu|
#        ABUAdSDK.preserve_paths = 'EyuLibrary-ios/Classes/framework/ReYunTracking/Headers/*.h'
#       'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ReYunTracking/Headers/**",
#        abu.preserve_paths = 'EyuLibrary-ios/Classes/framework/ABUAdSDK/*.framework'
        abu.vendored_frameworks = 'EyuLibrary-ios/Classes/framework/ABUAdSDK/*.framework'
        abu.dependency 'Google-Mobile-Ads-SDK','8.6.0'
        abu.dependency 'Ads-CN', '3.7.0.7'
        abu.dependency 'GDTMobSDK','4.12.81'
        abu.dependency 'UnityAds','3.7.2'
        abu.dependency 'SigmobAd-iOS', '3.1.2'
        abu.dependency 'MintegralAdSDK/InterstitialVideoAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK/RewardVideoAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK','6.9.4.0'
        abu.dependency 'MintegralAdSDK/BidNativeAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK/InterstitialAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK/BannerAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK/SplashAd','6.9.4.0'
        abu.dependency 'MintegralAdSDK/NativeAdvancedAd','6.9.4.0'
        abu.libraries = 'ABUAdSDK'
        abu.xcconfig = {'FRAMEWORK_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/framework/ABUAdSDK/**"}
#        abu.xcconfig = {'OTHER_LDFLAGS' => ['-ObjC', '-force_load', '$(PODS_ROOT)/../../EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdSDKAdapter', '-force_load', '${PODS_ROOT}/../../EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdAdmobAdapter', '-force_load', '${PODS_ROOT}/../../EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdGdtAdapter', '-force_load', '${PODS_ROOT}/../../EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdSigmobAdapter', '-force_load', '${PODS_ROOT}/../../EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUAdUnityAdapter']}
        abu.frameworks = 'CoreMotion', 'AdSupport'
        abu.libraries = 'z', 'c++', 'resolv'
#        abu.resource_bundles = {
#           'BUAdSDK' => ['EyuLibrary-ios/Classes/framework/ABUAdSDK/ABUVisualDebug.bundle']
#        }
        abu.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ABUADSDK_ENABLED'}
    end
    
    s.subspec 'mopub_ad_sdk' do |mopub|
        mopub.dependency 'mopub-ios-sdk', '5.16.2'
        mopub.dependency 'MoPub-Applovin-Adapters', '10.1.1.0'
        mopub.dependency 'MoPub-FacebookAudienceNetwork-Adapters', '6.3.0.0'
        mopub.dependency 'MoPub-AdMob-Adapters', '8.3.0.0'
        mopub.dependency 'MoPub-Pangle-Adapters', '3.5.1.0.0'
        mopub.dependency 'MoPub-UnityAds-Adapters', '3.6.0.1'
        mopub.dependency 'MoPub-Vungle-Adapters', '6.9.1.2'
        mopub.dependency 'FBSDKCoreKit','9.1.0'
        mopub.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MOPUB_ENABLED'}
    end
end
