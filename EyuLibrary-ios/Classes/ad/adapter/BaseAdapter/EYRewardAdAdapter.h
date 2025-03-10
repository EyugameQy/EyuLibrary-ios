//
//  IAd.h
//  ballzcpp-mobile
//
//  Created by Woo on 2017/12/19.
//

#import "EYAdAdapter.h"

@interface EYRewardAdAdapter : EYAdAdapter{
    
}

@property(nonatomic,strong)EYAdGroup *adGroup;
@property(nonatomic,strong)NSTimer *loadingTimer;
@property(nonatomic,assign)bool isShowing;




-(instancetype) initWithAdKey:(EYAdKey*)adKey adGroup:(EYAdGroup*) group;

-(void) loadAd;
-(bool) showAdWithController:(UIViewController*) controller;
-(bool) isAdLoaded;

-(void) notifyOnAdLoaded:(EYuAd *)eyuAd;
-(void) notifyOnAdLoadFailedWithError:(EYuAd *)eyuAd;
-(void) notifyOnAdShowed:(EYuAd *)eyuAd;
-(void) notifyOnAdClicked:(EYuAd *)eyuAd;
-(void) notifyOnAdRewarded:(EYuAd *)eyuAd;
-(void) notifyOnAdClosed:(EYuAd *)eyuAd;
-(void) notifyOnAdImpression:(EYuAd *)eyuAd;
-(void) notifyOnAdRevenue:(EYuAd *)eyuAd;

-(void) startTimeoutTask;
-(void) cancelTimeoutTask;

@end

