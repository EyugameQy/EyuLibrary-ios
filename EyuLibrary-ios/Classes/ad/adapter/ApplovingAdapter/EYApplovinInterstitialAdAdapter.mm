//
//  EYApplovinInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef APPLOVIN_ADS_ENABLED

#include "EYApplovinInterstitialAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface EYApplovinInterstitialAdAdapter() <ALAdLoadDelegate, ALAdDisplayDelegate>
@property (nonatomic, strong) ALAd *ad;
@end

@implementation EYApplovinInterstitialAdAdapter

@synthesize ad = _ad;

-(void) loadAd
{
    NSLog(@" applovin loadAd ad = %@", self.ad);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if(!self.isLoading){
        self.isLoading = true;
        [[ALSdk shared].adService loadNextAdForZoneIdentifier:self.adKey.key andNotify: self];
        [self startTimeoutTask];
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
    ad.mediator = @"applovin";
    return ad;
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" Applovin showAd [self isAdLoaded] = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        [ALInterstitialAd shared].adDisplayDelegate = self;
//        [ALInterstitialAd shared].adVideoPlaybackDelegate = self;
        
        [[ALInterstitialAd shared] showAd: self.ad];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.ad != NULL;
}

#pragma mark - Ad Load Delegate

- (void)adService:(nonnull ALAdService *)adService didLoadAd:(nonnull ALAd *)ad
{
    // We now have an interstitial ad we can show!
    NSLog(@" applovin didLoadAd adKey = %@", self.adKey);
    self.ad = ad;
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)adService:(nonnull ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    // Look at ALErrorCodes.h for the list of error codes.
        NSLog(@" applovin interstitial didFailToLoadAdWithError: %d, adKey = %@", code, self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = [[NSError alloc]initWithDomain:@"adloaderrordomain" code:code userInfo:nil];
    [self notifyOnAdLoadFailedWithError:ad];
}

#pragma mark - ALAdDisplayDelegate
/**
 * This method is invoked when the ad is displayed in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just displayed. Will not be nil.
 * @param view   Ad view in which the ad was displayed. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    if(self.ad == ad){
        NSLog(@" applovin interstitial ad wasDisplayedIn");
        [self notifyOnAdShowed: [self getEyuAd]];
        [self notifyOnAdImpression: [self getEyuAd]];
    }
}

/**
 * This method is invoked when the ad is hidden from in the view.
 * This occurs when the user "X's" out of an interstitial.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just hidden. Will not be nil.
 * @param view   Ad view in which the ad was hidden. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    if(self.ad == ad){
        NSLog(@" applovin interstitial ad wasHiddenIn");
        self.isShowing = NO;
        if(self.ad!= NULL)
        {
            self.ad = NULL;
        }
        [self notifyOnAdClosed: [self getEyuAd]];
    }
}

/**
 * This method is invoked when the ad is clicked from in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just clicked. Will not be nil.
 * @param view   Ad view in which the ad was hidden. Will not be nil.
 */
- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    if(self.ad == ad){
        NSLog(@" applovin interstitial ad wasClickedIn");
        [self notifyOnAdClicked: [self getEyuAd]];
    }
}

- (void)dealloc
{
    if(self.ad!= NULL)
    {
        self.ad = NULL;
    }
}

@end
#endif /*APPLOVIN_ADS_ENABLED*/
