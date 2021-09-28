//
//  EYApplovinRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef APPLOVIN_ADS_ENABLED

#include "EYApplovinRewardAdAdapter.h"
#import <AppLovinSDK/AppLovinSDK.h>


@interface EYApplovinRewardAdAdapter() <ALAdLoadDelegate, ALAdRewardDelegate, ALAdDisplayDelegate>

@property (nonatomic, strong) ALIncentivizedInterstitialAd *ad;

@end

@implementation EYApplovinRewardAdAdapter

-(void) loadAd
{
    NSLog(@" EYApplovinRewardAdAdapter loadAd #############. adId = #%@#", self.adKey.key);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded: [self getEyuAd]];
    }else if(!self.isLoading)
    {
        self.isLoading = true;
        if(self.ad == NULL )
        {
            self.ad = [[ALIncentivizedInterstitialAd alloc] initWithZoneIdentifier:self.adKey.key];
        }
        [self startTimeoutTask];
        [self.ad preloadAndNotify:self];
    }else{
        if(self.loadingTimer == nil)
        {
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@" EYApplovinRewardAdAdapter showAd #############.");
    if([self isAdLoaded])
    {
        self.isShowing = YES;
        self.isRewarded = NO;
        self.ad.adDisplayDelegate = self;
        [self.ad showAndNotify:self];
        return true;
    }
    return false;
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"apploving";
    return ad;
}

-(bool) isAdLoaded
{
    return self.ad != NULL && [self.ad isReadyForDisplay];
}

#pragma mark - Ad Load Delegate

- (void)adService:(nonnull ALAdService *)adService didLoadAd:(nonnull ALAd *)ad
{
    // We now have an interstitial ad we can show!
    NSLog(@" applovin didLoadAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded: [self getEyuAd]];
}

- (void)adService:(nonnull ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    // Look at ALErrorCodes.h for the list of error codes.
    NSLog(@" applovin reward didFailToLoadAdWithError: %d, adKey = %@", code, self.adKey);
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
//    if(self.ad == ad){
        NSLog(@" applovin reward ad wasDisplayedIn");
        [self notifyOnAdShowed:[self getEyuAd]];
        [self notifyOnAdImpression:[self getEyuAd]];
//    }
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
    NSLog(@" applovin reward ad wasHiddenIn isRewarded = %d", self.isRewarded);
    self.isShowing = NO;
    if(self.isRewarded){
        [self notifyOnAdRewarded:[self getEyuAd]];
        self.isRewarded = false;
    }
    [self notifyOnAdClosed:[self getEyuAd]];
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
    NSLog(@" applovin reward ad wasClickedIn");
    [self notifyOnAdClicked:[self getEyuAd]];
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response
{
    /* AppLovin servers validated the reward. Refresh user balance from your server. We will also pass the number of coins
     awarded and the name of the currency. However, ideally, you should verify this with your server before granting it. */
    NSLog(@" applovin reward ad didSucceedWithResponse %@", response);
    self.isRewarded = true;
}

- (void)rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response
{
    // The user's reward was marked as fraudulent, they are most likely trying to modify their balance illicitly.
    NSLog(@" applovin reward ad wasRejectedWithResponse %@", response);
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode
{
    NSLog(@" applovin reward ad didFailWithError %d", responseCode);
    if ( responseCode == kALErrorCodeIncentivizedValidationNetworkTimeout )
    {
        // The SDK was unable to reach AppLovin over the network. The user's device is likely experiencing poor connectivity.
        self.isRewarded = true;
    }
    else if ( responseCode == kALErrorCodeIncentivizedUserClosedVideo )
    {
        /* Indicates the user has exited a video prior to completion. You may have already received didSucceedWithResponse.
         If you choose, to handle this case, you may optionally cancel the previously granted reward (if any). */
    }
    else
    {
        /* Something else went wrong. Wait a bit before showing another rewarded video. */
        self.isRewarded = true;
    }
}

- (void)rewardValidationRequestForAd:(ALAd *)ad didExceedQuotaWithResponse:(NSDictionary *)response { /* No longer used */ }
@end

#endif /*APPLOVIN_ADS_ENABLED*/
