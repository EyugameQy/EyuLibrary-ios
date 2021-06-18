//
//  EYAdConstants.h
//  EyuLibrary-ios_Example
//
//  Created by qianyuan on 2018/10/17.
//  Copyright © 2018年 WeiqiangLuo. All rights reserved.
//

#ifndef EYAdConstants_h
#define EYAdConstants_h

#define     ADNetworkFacebook               @"facebook"
#define     ADNetworkAdmob                  @"admob"
#define     ADNetworkUnity                  @"unity"
#define     ADNetworkVungle                 @"vungle"
#define     ADNetworkApplovin               @"applovin"
#define     ADNetworkMAX                    @"max"
#define     ADNetworkWM                     @"wm"
#define     ADNetworkGdt                    @"gdt"
#define     ADNetworkMtg                    @"mintegral"
#define     ADNetworkIronSource             @"ironsource"
#define     ADNetworkAnyThink               @"anythink"
#define     ADNetworkTradPlus               @"tradplus"
#define     ADNetworkABU                    @"abu"
#define     ADNetworkMopub                  @"mopub"


#define     ADTypeInterstitial            @"interstitialAd"
#define     ADTypeNative                  @"nativeAd"
#define     ADTypeReward                  @"rewardAd"
#define     ADTypeBanner                  @"bannerAd"
#define     ADTypeSplash                  @"splashAd"

#define     EVENT_LOADING  @"_LOADING"
#define     EVENT_SHOW  @"_SHOW"
#define     EVENT_LOAD_FAILED  @"_LOAD_FAILED"
#define     EVENT_LOAD_SUCCESS  @"_LOAD_SUCCESS"
#define     EVENT_REWARDED  @"_REWARDED"
#define     EVENT_CLICKED  @"_CLICKED"
#define     EVENT_CONVERSION  @"conversion"
#define     EVENT_FBCONVERSION  @"fb_conversion"
#define     EVENT_AD_IMPRESSION  @"eyu_ad_impression"


#define     ERROR_SDK_UNINITED                          -10001
#define     ERROR_OTHER_ADMOB_REWARD_AD_LOADED          -11001
#define     ERROR_OTHER_ADMOB_REWARD_AD_LOADING         -11002
#define     ERROR_UNITY_AD_NOT_LOADED                   -12001
#define     ERROR_IRON_SOURCE_AD_NOT_LOADED             -12002
#define     ERROR_TIMEOUT                               -13001
#define     ERROR_AD_IS_SHOWING                         -13002
#define     ERROR_IS_AD_LOAD_ERROR                      -13003

static int TIMEOUT_TIME;
#endif /* EYAdConstants_h */
