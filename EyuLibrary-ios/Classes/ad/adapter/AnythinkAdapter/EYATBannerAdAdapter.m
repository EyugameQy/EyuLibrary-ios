//
//  EYATBannerAdAdapter.m
//  EyuLibrary-ios
//
//  Created by eric on 2020/11/23.
//
#ifdef ANYTHINK_ENABLED
#import "EYATBannerAdAdapter.h"
#include "EYAdManager.h"

@implementation EYATBannerAdAdapter
-(void) loadAd
{
    NSLog(@"at bannerAd ");
    if([self isAdLoaded])
    {
        [self notifyOnAdLoaded];
        return;
    } else if (!self.isLoading) {
        self.isLoading = true;
        [[ATAdManager sharedManager] loadADWithPlacementID:self.adKey.key extra:@{kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 50)], kATAdLoadingExtraBannerSizeAdjustKey:@NO} delegate:self];
        [self startTimeoutTask];
    } else {
        if(self.loadingTimer == nil){
            [self startTimeoutTask];
        }
    }
}

- (bool)isAdLoaded {
    return [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.adKey.key];
}

- (bool)showAdGroup:(UIView *)viewGroup {
    if (![self isAdLoaded]) {
        return false;
    }
    viewGroup.bannerAdapter = self;
    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.adKey.key];
    bannerView.delegate = self;
    bannerView.presentingViewController = EYAdManager.sharedInstance.rootViewController;
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [viewGroup layoutIfNeeded];
//    bannerView.frame = viewGroup.bounds;
    CGFloat w = viewGroup.frame.size.width;
    CGFloat h = viewGroup.frame.size.height;
    if (w == 0 || h == 0) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = 50;
    };
    [viewGroup addSubview:bannerView];
//    viewGroup.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewGroup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
    [viewGroup addConstraint:centerX];
    [viewGroup addConstraint:centerY];
    [viewGroup addConstraint:width];
    [viewGroup addConstraint:height];
    return true;
}

#pragma mark - loading delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"atbanner ad didLoad");
    self.isLoading = false;
    [self notifyOnAdLoaded];
}

-(void) didFailToLoadADWithPlacementID:(NSString* )placementID error:(NSError *)error {
    NSLog(@"at banner ad failed to load with error: %@", error);
    self.isLoading = false;
    [self notifyOnAdLoadFailedWithError:(int)error.code];
}

#pragma mark - banner delegate

-(void) bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATBannerViewController::bannerView:failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
}
-(void) bannerView:(ATBannerView*)bannerView didTapCloseButtonWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerView:didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
}

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATBannerViewController::bannerView:didAutoRefreshWithPlacement:%@", placementID);
}


- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"at bannerad didClick");
    [self notifyOnAdClicked];
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"atbanner ad willLogImpression");
    [self notifyOnAdShowed];
    [self notifyOnAdShowedData:extra];
    [self notifyOnAdImpression];
}

- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    
}

@end
#endif