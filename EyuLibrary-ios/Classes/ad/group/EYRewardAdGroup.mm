//
//  RewardAdGroup.m
//  Freecell
//
//  Created by apple on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import "EYRewardAdGroup.h"
#import "EYAdKey.h"
#import "EYEventUtils.h"
#import "SVProgressHUD.h"
#import <FFToast/FFToast.h>
#import "EyAdManager.h"

@interface EYRewardAdGroup()

//@property(nonatomic,strong)NSMutableArray<EYRewardAdAdapter*> *adapterArray;
@property(nonatomic,strong)NSDictionary<NSString*, Class> *adapterClassDict;
//@property(nonatomic,assign)int  maxTryLoadAd;
//@property(nonatomic,assign)int tryLoadAdCounter;
//@property(nonatomic,assign)int curLoadingIndex;
@property(nonatomic,assign)bool isLoadingDialogShowed;
@property(nonatomic,strong)NSTimer *loadingTimer;
//@property(nonatomic,assign)bool reportEvent;

@end

@implementation EYRewardAdGroup

//@synthesize adGroup = _adGroup;
//@synthesize adapterArray = _adapterArray;
@synthesize adapterClassDict = _adapterClassDict;
//@synthesize maxTryLoadAd = _maxTryLoadAd;
//@synthesize curLoadingIndex = _curLoadingIndex;
//@synthesize tryLoadAdCounter = _tryLoadAdCounter;
@synthesize isLoadingDialogShowed = _isLoadingDialogShowed;
@synthesize loadingTimer = _loadingTimer;
//@synthesize delegate = _delegate;
//@synthesize reportEvent = _reportEvent;

- (EYRewardAdGroup *)initInAdvanceWithGroup:(EYAdGroup *)adGroup adConfig:(EYAdConfig *)adConfig {
    if (adConfig.isNewJsonSetting == false) {
        return [self initWithGroup:adGroup adConfig:adConfig];
    }
    self.adType = ADTypeReward;
    self = [super initInAdvanceWithGroup:adGroup adConfig:adConfig];
    return self;
}

-(EYRewardAdGroup*) initWithGroup:(EYAdGroup*)group adConfig:(EYAdConfig*) adConfig
{
    self = [super initWithGroup:group adConfig:adConfig];
    if(self)
    {
        self.adapterClassDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef FB_ADS_ENABLED
                                 NSClassFromString(@"EYFbRewardAdAdapter"), ADNetworkFacebook,
#endif
                                 
#ifdef ADMOB_ADS_ENABLED
                                 NSClassFromString(@"EYAdmobRewardAdAdapter"), ADNetworkAdmob,
#endif
                                 
#ifdef UNITY_ADS_ENABLED
                                 NSClassFromString(@"EYUnityRewardAdAdapter"), ADNetworkUnity,
#endif
                                 
#ifdef VUNGLE_ADS_ENABLED
                                 NSClassFromString(@"EYVungleRewardAdAdapter"), ADNetworkVungle,
#endif
                                 
#ifdef APPLOVIN_ADS_ENABLED
                                 NSClassFromString(@"EYApplovinRewardAdAdapter"), ADNetworkApplovin,
#endif
                                 
#ifdef APPLOVIN_MAX_ENABLED
                                 NSClassFromString(@"EYMaxRewardAdAdapter"), ADNetworkMAX,
#endif
                                 
#ifdef BYTE_DANCE_ADS_ENABLED
                                 NSClassFromString(@"EYWMRewardAdAdapter"), ADNetworkWM,
#endif
                                 
#ifdef GDT_ADS_ENABLED
                                 NSClassFromString(@"EYGdtRewardAdAdapter"), ADNetworkGdt,
#endif
                                 
#ifdef MTG_ADS_ENABLED
                                 NSClassFromString(@"EYMtgRewardAdAdapter"), ADNetworkMtg,
#endif
                                 
#ifdef IRON_ADS_ENABLED
                                 NSClassFromString(@"EYIronSourceRewardAdAdapter"), ADNetworkIronSource,
#endif
#ifdef ANYTHINK_ENABLED
                                 NSClassFromString(@"EYATRewardAdAdapter"), ADNetworkAnyThink,
#endif
#ifdef TRADPLUS_ENABLED
                                 NSClassFromString(@"EYTPRewardAdAdapter"), ADNetworkTradPlus,
#endif
#ifdef ABUADSDK_ENABLED
                                 NSClassFromString(@"EYABURewardAdAdapter"), ADNetworkABU,
#endif
#ifdef MOPUB_ENABLED
                                 NSClassFromString(@"EYMopubRewardAdAdapter"), ADNetworkMopub,
#endif
                                 nil];
        
        //        self.adGroup = group;
        self.adValueKey = [NSString stringWithFormat:@"currentRewardValue%d", self.priority+1];
        self.adType = ADTypeReward;
        [self initAdatperArray];
        
        //        NSArray<EYAdKey*>* keyList = group.keyArray;
        
        //        for(EYAdKey* adKey:keyList)
        //        {
        //            if(adKey){
        //                EYRewardAdAdapter *adapter = [self createAdAdapterWithKey:adKey adGroup:group];
        //                if(adapter){
        //                    [self.adapterArray addObject:adapter];
        //                }
        //            }
        //        }
        
        self.maxTryLoadAd = ((int)self.adapterArray.count) * 2;
        
    }
    return self;
}

//-(void) loadAd:(NSString*) placeId
//{
//    NSLog(@"EYRewardAdGroup loadAd placeId = %@, self.curLoadingIndex = %d", placeId, self.curLoadingIndex);
//    self.adPlaceId = placeId;
//    if(self.adapterArray.count == 0) return;
//    self.curLoadingIndex = 0;
//    self.tryLoadAdCounter = 1;
//
//    EYRewardAdAdapter* adapter = self.adapterArray[0];
//    [adapter loadAd];
//
//    if(self.adapterArray.count > 1)
//    {
//        EYRewardAdAdapter* adapter = self.adapterArray[1];
//        [adapter loadAd];
//        self.curLoadingIndex = 1;
//        self.tryLoadAdCounter = 2;
//    }
//
//    if(self.reportEvent){
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:adapter.adKey.keyId forKey:@"type"];
//        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_LOADING]  parameters:dic];
//    }
//}

-(bool) showAd:(NSString*) adPlaceId controller:(UIViewController*) controller
{
    NSLog(@"showAd placeId = %@", adPlaceId);
    if (self.groupArray != nil) {
        for (EYRewardAdGroup *group in self.groupArray) {
            if ([group showAd:adPlaceId controller:controller]) {
                return true;
            }
        }
        return false;
    }
    self.adPlaceId = adPlaceId;
    EYRewardAdAdapter* loadAdapter = NULL;
    for(EYRewardAdAdapter* adapter in self.adapterArray)
    {
        if([adapter isAdLoaded])
        {
            loadAdapter = adapter;
            break;
        }
    }
    if(loadAdapter!=NULL)
    {
        loadAdapter.adKey.placementid = self.adPlaceId;
        [loadAdapter showAdWithController:controller];
        return true;
    }else{
        [self showLoadingDialog];
        [self loadAd:self.adPlaceId];
        return false;
    }
}

-(EYRewardAdAdapter*) createAdAdapterWithKey:(EYAdKey*)adKey adGroup:(EYAdGroup*)group
{
    EYRewardAdAdapter* adapter = NULL;
    NSString* network = adKey.network;
    Class adapterClass = self.adapterClassDict[network];
    if(adapterClass!= NULL){
        adapter = [[adapterClass alloc] initWithAdKey:adKey adGroup:group];
    }
    if(adapter != NULL)
    {
        adapter.delegate = self;
    }
    return adapter;
}

-(void) showLoadingDialog
{
    self.isLoadingDialogShowed = true;
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (self.loadingTimer == nil) {
        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeout) userInfo:nil repeats:false];
    }
}

-(void) hideLoadingDialog
{
    if (self.loadingTimer != nil) {
        [self.loadingTimer invalidate];
        self.loadingTimer = nil;
    }
    self.isLoadingDialogShowed = false;
    [SVProgressHUD dismiss];
}

- (void) timeout{
    NSLog(@" timeout");
    [self showLoadAdFailedToast];
    [self hideLoadingDialog];
    if(self.delegate)
    {
        EYuAd *eyuAd = [EYuAd new];
        eyuAd.adFormat = ADTypeReward;
        eyuAd.placeId = self.adPlaceId;
        eyuAd.error = [[NSError alloc]initWithDomain:@"timeoutDomian" code:ERROR_TIMEOUT userInfo:nil];
        [self.delegate onAdShowLoadFailed:eyuAd];
    }
}

-(void) showLoadAdFailedToast
{
    [FFToast showToastWithTitle:NSLocalizedString(@"sorry", @"Sorry") message:NSLocalizedString(@"ad_load_failed", @"Ads is not available，try again later") iconImage:nil duration:3 toastType:FFToastTypeDefault];
}

//-(void) onAdShowLoadFailed:(EYRewardAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd
//{
//    [super onAdShowLoadFailed:adapter eyuAd:eyuAd];
//}

-(void) onAdLoaded:(EYRewardAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd
{
    [super onAdLoaded:adapter eyuAd:eyuAd];
    if(self.isLoadingDialogShowed)
    {
        [self hideLoadingDialog];
        UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self showAd:self.adPlaceId controller:controller];
    }
}


-(void) onAdLoadFailed:(EYRewardAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    [super onAdLoadFailed:adapter eyuAd:eyuAd];
}

-(void) onAdShowed:(EYRewardAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdShowed:eyuAd];
    }
    //    if(self.reportEvent){
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:adapter.adKey.keyId forKey:@"type"];
    [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_SHOW]  parameters:dic];
    //    }
}

- (void)onAdRevenue:(EYAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onAdRevenue:)])
    {
        [self.delegate onAdRevenue:eyuAd];
    }
}

-(void) onAdClicked:(EYRewardAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdClicked:eyuAd];
    }
    if(self.reportEvent){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adapter.adKey.keyId forKey:@"type"];
        [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_CLICKED]  parameters:dic];
    }
}

-(void) onAdClosed:(EYRewardAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdClosed:eyuAd];
    }
    if (self.adGroup.isAutoLoad && !self.isCacheAvailable) {
        [self loadAd:self.adPlaceId];
    }
}

-(void) onAdRewarded:(EYRewardAdAdapter *)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdReward:eyuAd];
    }
    
    //    if(self.reportEvent){
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:adapter.adKey.keyId forKey:@"type"];
    [EYEventUtils logEvent:[self.adGroup.groupId stringByAppendingString:EVENT_REWARDED]  parameters:dic];
    //    }
}

-(void) onAdImpression:(EYRewardAdAdapter*)adapter eyuAd:(EYuAd *)eyuAd
{
    if(self.delegate)
    {
        [self.delegate onAdImpression:eyuAd];
    }
    EYAdKey *adKey = adapter.adKey;
    if(adKey){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:adKey.network forKey:@"network"];
        [dic setObject:adKey.key forKey:@"unit"];
        [dic setObject:ADTypeReward forKey:@"type"];
        [dic setObject:adKey.keyId forKey:@"keyId"];
        [EYEventUtils logEvent:EVENT_AD_IMPRESSION  parameters:dic];
    }
}
@end
