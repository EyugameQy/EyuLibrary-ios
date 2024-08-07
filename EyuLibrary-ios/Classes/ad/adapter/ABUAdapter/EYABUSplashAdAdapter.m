//
//  EYABUSplashAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/3/5.
//

#ifdef ABUADSDK_ENABLED

#import "EYABUSplashAdAdapter.h"

@implementation EYABUSplashAdAdapter
-(void) loadAd
{
    NSLog(@"abusplash loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if(![self isLoading])
    {
        if(self.splashAd!=NULL)
        {
            self.splashAd.delegate = nil;
        }
        self.isLoading = true;
        self.splashAd = [[ABUSplashAd alloc] initWithAdUnitID:self.adKey.key];
        self.splashAd.delegate = self;
        self.splashAd.tolerateTimeout = 3.f;
//        self.splashAd.getExpressAdIfCan = YES;
        
        ABUSplashUserData *userData = [[ABUSplashUserData alloc] init];
        userData.adnType = ABUAdnPangle;
        userData.appID = ABUAdSDKManager.appID;     // 如果使用穿山甲兜底，请务必传入与MSDK初始化时一致的appID
        userData.rit = self.adKey.key;   // 开屏对应的代码位
        NSError *error = nil;
        // 在广告位配置拉取失败后，会使用传入的rit和appID兜底，进行广告加载，需要在创建manager时就调用该接口（仅支持穿山甲/GDT/百度）
        [self.splashAd setUserData:userData error:&error];
        // ！！！如果有错误信息说明setUserData调用有误，需按错误提示重新设置
        if (error) {
            NSLog(@"开屏兜底配置错误----%@", error);
        }
        // 广告加载, 前置设置无错误时在加载广告
        [self.splashAd loadAdData];
        [self startTimeoutTask];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"abu splashAd showAd ");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.splashAd.rootViewController = controller;
        [self.splashAd showInWindow:[[UIApplication sharedApplication] keyWindow]];
    }
    return false;
}

-(bool) isAdLoaded
{
    NSLog(@"abu splashAd isAdLoaded , splashAd = %@", self.splashAd);
    return self.splashAd != NULL && self.isLoadSuccess;
}

#pragma mark <---ABUSplashAdDelegate--->
/**
 This method is called when splash ad material loaded successfully.
 */
- (void)splashAdDidLoad:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdDidLoad");
    self.isLoadSuccess = true;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeSplash;
    ad.mediator = @"abu";
    return ad;
}

/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 */
- (void)splashAd:(ABUSplashAd *_Nonnull)splashAd didFailWithError:(NSError *_Nullable)error {
    self.isLoadSuccess = false;
    NSLog(@"abu splashAd didFailWithError");
    [self.splashAd destoryAd];
    if(self.splashAd != NULL)
    {
        self.splashAd.delegate = NULL;
        self.splashAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillVisible:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdWillVisible");
    EYuAd *ad = [self getEyuAd];
    [self notifyOnAdImpression: ad];
    ad.adRevenue = splashAd.getPreEcpm;
    [self notifyOnAdRevenue:ad];
}

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdDidClick");
    [self notifyOnAdClicked: [self getEyuAd]];
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(ABUSplashAd *_Nonnull)splashAd {
    [self.splashAd destoryAd];
    NSLog(@"abu splashAd splashAdDidClose");
    if(self.splashAd != NULL)
    {
        self.splashAd.delegate = NULL;
        self.splashAd = NULL;
    }
    [self notifyOnAdClosed: [self getEyuAd]];
}

/**
 This method is called when splash ad is about to close.
 */
- (void)splashAdWillClose:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdWillClose");
}

/**
 * This method is called when FullScreen modal has been presented.
 *  弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdWillPresentFullScreenModal");
}

- (void)splashAdWillDissmissFullScreenModal:(ABUSplashAd *)splashAd {
    NSLog(@"abu splashAd splashAdWillDissmissFullScreenModal");
}

/**
 This method is called when spalashAd countdown equals to zero
 */
- (void)splashAdCountdownToZero:(ABUSplashAd *_Nonnull)splashAd {
    NSLog(@"abu splashAd splashAdCountdownToZero");
}
@end

#endif
