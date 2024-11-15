//
//  EYGdtInterstitialAdAdapter.mm
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//

#ifdef GDT_ADS_ENABLED
#include "EYGdtInterstitialAdAdapter.h"
//#import "GDTMobInterstitial.h"
#import "GDTUnifiedInterstitialAd.h"
#import "EYAdManager.h"

@interface EYGdtInterstitialAdAdapter()<GDTUnifiedInterstitialAdDelegate>

@property(nonatomic,strong)GDTUnifiedInterstitialAd *interstitialAd;

@end


@implementation EYGdtInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;
 
-(void) loadAd
{
    NSLog(@"gdt interstitialAd loadAd ");
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if(self.interstitialAd == NULL)
    {
        EYAdManager* manager = [EYAdManager sharedInstance];
        NSString* appId = manager.adConfig.gdtAppId;
        self.interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithAppId:appId placementId:self.adKey.key];
        self.interstitialAd.delegate = self;
        self.isLoading = true;
        [self.interstitialAd loadAd];
        [self startTimeoutTask];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded:[self getEyuAd]];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeInterstitial;
    ad.mediator = @"gdt";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"gdt interstitialAd showAd ");
    if([self isAdLoaded])
    {
        [self.interstitialAd presentFullScreenAdFromRootViewController:controller];
        self.isShowing = YES;
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@"gdt interstitialAd isAdLoaded , interstitialAd = %@", self.interstitialAd);
    return self.interstitialAd != NULL && [self.interstitialAd isAdValid];
}

#pragma mark - GDTUnifiedInterstitialAdDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt interstitialAd interstitialSuccessToLoadAd");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded:[self getEyuAd]];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error;
{
    NSLog(@" gdt interstitialFailToLoadAd, error = %@", error);
    self.isLoading = false;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

// 插屏广告视图展示成功回调
// 详解: 插屏广告展示成功回调该函数
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt interstitialDidPresentScreen");
    [self notifyOnAdShowed:[self getEyuAd]];
}

// 插屏广告展示结束回调
// 详解: 插屏广告展示结束回调该函数
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt unifiedInterstitialDidDismissScreen");
    self.isShowing = NO;
    if(self.interstitialAd != NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self notifyOnAdClosed:[self getEyuAd]];
}

/**
 *  插屏广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt interstitialClicked");
    [self notifyOnAdClicked:[self getEyuAd]];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt interstitialDidPresentScreen");
    [self notifyOnAdImpression:[self getEyuAd]];
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial;
{
    NSLog(@" gdt interstitialAdDidDismissFullScreenModal");
}

- (void)dealloc
{
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
}

@end
#endif /*GDT_ADS_ENABLED*/
