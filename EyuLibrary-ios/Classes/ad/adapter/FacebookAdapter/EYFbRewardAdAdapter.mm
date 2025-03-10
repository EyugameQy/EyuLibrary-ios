//
//  FbRewardAdAdapter.cpp
//  ballzcpp-mobile
//
//  Created by apple on 2018/3/9.
//
#ifdef FB_ADS_ENABLED

#include "EYFbRewardAdAdapter.h"


@implementation EYFbRewardAdAdapter

@synthesize isRewarded = _isRewarded;
@synthesize rewardAd = _rewardAd;

-(void) loadAd
{
    NSLog(@"fb loadAd isAdLoaded = %d", [self isAdLoaded]);
    if([self isShowing ]){
        EYuAd *ad = [self getEyuAd];
        ad.error = [[NSError alloc]initWithDomain:@"isshowingdomain" code:ERROR_AD_IS_SHOWING userInfo:nil];
        [self notifyOnAdLoadFailedWithError:ad];
    }else if([self isAdLoaded])
    {
        [self notifyOnAdLoaded:[self getEyuAd]];
    }else if(![self isLoading] )
    {
        if(self.rewardAd!=NULL)
        {
            self.rewardAd.delegate = nil;
        }
        self.isLoading = true;
        self.rewardAd = [[FBRewardedVideoAd alloc] initWithPlacementID:self.adKey.key];
        self.rewardAd.delegate = self;
        [self startTimeoutTask];
        [self.rewardAd loadAd];
    }else{
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

-(bool) showAdWithController:(UIViewController*) controller
{
    NSLog(@"fb showAd ");
    if([self isAdLoaded])
    {
        bool result = [self.rewardAd showAdFromRootViewController:controller];
        if(result)
        {
            self.isShowing = YES;
            [self notifyOnAdShowed:[self getEyuAd]];
        }
        return result;
    }
    return false;
}

-(EYuAd *) getEyuAd{
    EYuAd *ad = [EYuAd new];
    ad.unitId = self.adKey.key;
    ad.unitName = self.adKey.keyId;
    ad.placeId = self.adKey.placementid;
    ad.adFormat = ADTypeReward;
    ad.mediator = @"facebook";
    return ad;
}

-(bool) isAdLoaded
{
    bool isAdLoaded = self.rewardAd != NULL && [self.rewardAd isAdValid];
    NSLog(@"fb Reward video ad isAdLoaded = %d", isAdLoaded);
    return isAdLoaded;
}

/**
 Sent when an ad has been successfully loaded.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"fb Reward video ad is loaded.");
    self.isLoading = false;
    [self cancelTimeoutTask];
    [self notifyOnAdLoaded:[self getEyuAd]];
}

/**
 Sent after an FBRewardedVideoAd object has been dismissed from the screen, returning control
 to your application.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"fb Reward video ad is closed.");
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    
    if(self.isRewarded){
        [self notifyOnAdRewarded:[self getEyuAd]];
    }
    self.isShowing = NO;
    self.isRewarded = NO;
    [self notifyOnAdClosed:[self getEyuAd]];
}

/**
 Sent after an FBRewardedVideoAd fails to load the ad.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 - Parameter error: An error object containing details of the error.
 */
- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"fb Reward video ad is failed to load. error = %d", (int)error.code);
    self.isLoading = false;
    if(self.rewardAd != NULL ){
        self.rewardAd.delegate = NULL;
        self.rewardAd = NULL;
    }
    [self cancelTimeoutTask];
    EYuAd *ad = [self getEyuAd];
    ad.error = error;
    [self notifyOnAdLoadFailedWithError:ad];
}

/**
 Sent after the FBRewardedVideoAd object has finished playing the video successfully.
 Reward the user on this callback.
 
 - Parameter rewardedVideoAd: An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdVideoComplete:(FBRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"fb Reward video ad is showed.");
    self.isRewarded = true;
}

/**
  Sent immediately before the impression of an FBRewardedVideoAd object will be logged.

 @param rewardedVideoAd An FBRewardedVideoAd object sending the message.
 */
- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self notifyOnAdImpression:[self getEyuAd]];
}
@end
#endif /*FB_ADS_ENABLED*/
