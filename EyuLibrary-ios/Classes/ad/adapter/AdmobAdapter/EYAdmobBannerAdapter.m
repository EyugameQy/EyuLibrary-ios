//
//  EYAdmobBannerAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/7.
//


//#include "EYBannerAdAdapter.h"

#ifdef ADMOB_ADS_ENABLED
#include "EYAdmobBannerAdapter.h"
#include "EYAdManager.h"
#ifdef ADMOB_MEDIATION_ENABLED
#import <VungleAdapter/VungleAdapter.h>
#endif

@interface EYAdmobBannerAdapter()
@property(nonatomic,assign)bool adLoaded;
@end

@implementation EYAdmobBannerAdapter
@synthesize bannerAdView = _bannerAdView;

- (instancetype)initWithAdKey:(EYAdKey *)adKey adGroup:(EYAdGroup *)group {
    self = [super initWithAdKey:adKey adGroup:group];
    if (self) {
        self.adLoaded = false;
    }
    return self;
}
-(void) loadAd
{
    NSLog(@"admob bannerAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        if (self.bannerAdView == NULL) {
            self.isLoading = true;
            self.bannerAdView = [[GADBannerView alloc]initWithAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth([UIScreen mainScreen].bounds.size.width)];
            self.bannerAdView.adUnitID = self.adKey.key;
            self.bannerAdView.rootViewController = EYAdManager.sharedInstance.rootViewController;
            self.bannerAdView.delegate = self;
            self.bannerAdView.translatesAutoresizingMaskIntoConstraints = NO;
            GADRequest *request = [[GADRequest alloc] init];
#ifdef ADMOB_MEDIATION_ENABLED
        VungleAdNetworkExtras *extras = [[VungleAdNetworkExtras alloc] init];
        extras.allPlacements = [EYAdManager sharedInstance].vunglePlacementIds;
        [request registerAdNetworkExtras:extras];
#endif
            [self.bannerAdView loadRequest:request];
            [self startTimeoutTask];
        }
    } else {
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (self.bannerAdView == NULL) {
        return false;
    }
    viewGroup.bannerAdapter = self;
    [self.bannerAdView removeFromSuperview];
//    CGRect bounds = CGRectMake(0,0, self.bannerAdView.frame.size.width, self.bannerAdView.frame.size.height);
//    NSLog(@"bannerAdView witdh = %f, height = %f ", bounds.size.width, bounds.size.height);
//    self.bannerAdView.frame = bounds;
    CGFloat w = self.bannerAdView.frame.size.width;
    CGFloat h = self.bannerAdView.frame.size.height;
    if (w == 0 || h == 0) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = 50;
    };
//    viewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    [viewGroup addSubview:self.bannerAdView];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.bannerAdView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

- (UIView *)getBannerView {
    return self.bannerAdView;
}

-(bool) isAdLoaded
{
    return self.adLoaded;
}

#pragma mark GADBannerViewDelegate implementation
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    self.isLoading = false;
    self.adLoaded = true;
    [self notifyOnAdLoaded];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    self.isLoading = false;
    self.adLoaded = false;
    [self.delegate onAdLoadFailed:self withError:(int)error.code];
    NSLog(@"admob banner:didFailToReceiveAdWithError: %@, adKey = %@", [error localizedDescription], self.adKey);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
    [self notifyOnAdImpression];
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"admob bannerWillPresentScreen");
    self.isShowing = true;
    [self notifyOnAdShowed];
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"admob bannerWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"admob bannerDidDismissScreen");
    self.isShowing = false;
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"admob bannerWillLeaveApplication");
    [self notifyOnAdClicked];
}
@end
#endif /*ADMOB_ADS_ENABLED*/