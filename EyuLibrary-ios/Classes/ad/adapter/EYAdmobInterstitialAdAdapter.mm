//
//  AdmobInterstitialAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef ADMOB_ADS_ENABLED
#ifdef ADMOB_MEDIATION_ENABLED
#import <VungleAdapter/VungleAdapter.h>
#import "EYAdManager.h"
#endif
#include "EYAdmobInterstitialAdAdapter.h"


@implementation EYAdmobInterstitialAdAdapter

@synthesize interstitialAd = _interstitialAd;

-(void) loadAd
{
    NSLog(@"lwq, admob loadAd interstitialAd = %@", self.interstitialAd);
    if([self isShowing ]){
        [self notifyOnAdLoadFailedWithError:ERROR_AD_IS_SHOWING];
    }else if(self.interstitialAd == NULL)
    {
        self.interstitialAd = [[GADInterstitial alloc] initWithAdUnitID:self.adKey.key];
        self.interstitialAd.delegate = self;
        GADRequest *request = [GADRequest request];
        //request.testDevices = @[ @"9b80927958fbfef89ca335966239ca9a",@"46fd4577df207ecb050bffa2948d5e52" ];
#ifdef ADMOB_MEDIATION_ENABLED
        VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];
        extras.allPlacements = [EYAdManager sharedInstance].vunglePlacementIds;
        [request registerAdNetworkExtras:extras];
#endif
        [self.interstitialAd loadRequest:request];
        [self startTimeoutTask];
        self.isLoading = true;
    }else if([self isAdLoaded]){
        [self notifyOnAdLoaded];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"lwq, admob showAd [self isAdLoaded] = %d", [self isAdLoaded]);
    if([self isAdLoaded])
    {
        self.isShowing = true;
        [self.interstitialAd presentFromRootViewController:controller];
        return true;
    }
    return false;
}

-(bool) isAdLoaded
{
    return self.interstitialAd != NULL && [self.interstitialAd isReady];
}

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"lwq, admob interstitialDidReceiveAd adKey = %@", self.adKey);
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded];
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"lwq, admob interstitial:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
    self.isLoading = false;
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    [self cancelTimeoutTask];
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"lwq, admob interstitialWillPresentScreen");
    [self notifyOnAdShowed];
    [self notifyOnAdImpression];
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"lwq, admob interstitialWillDismissScreen");
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"lwq, admob interstitialDidDismissScreen");
    if(self.interstitialAd!= NULL)
    {
        self.interstitialAd.delegate = NULL;
        self.interstitialAd = NULL;
    }
    self.isShowing = false;
    [self notifyOnAdClosed];
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"lwq, admob interstitialWillLeaveApplication");
    [self notifyOnAdClicked];
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

#endif /*ADMOB_ADS_ENABLED*/
