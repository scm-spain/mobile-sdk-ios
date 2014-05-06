/*   Copyright 2013 APPNEXUS INC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "ANBasicConfig.h"
#import ANADADAPTERBANNERIADHEADER

@interface ANADADAPTERBANNERIAD ()
@property (nonatomic, readwrite, strong) id bannerView;
@end

@implementation ANADADAPTERBANNERIAD
@synthesize delegate;

#pragma mark ANCustomAdapterBanner

// iAd doesn't have use placement id
- (void)requestBannerAdWithSize:(CGSize)size
             rootViewController:(UIViewController *)rootViewController
                serverParameter:(NSString *)parameterString
                       adUnitId:(NSString *)idString
            targetingParameters:(ANTARGETINGPARAMETERS *)targetingParameters
{
    NSLog(@"Requesting iAd banner");
    Class iAdBannerClass = NSClassFromString(@"ADBannerView");
    if (iAdBannerClass) {
        self.bannerView = [[iAdBannerClass alloc] initWithAdType:ADAdTypeBanner];
        [self.bannerView setDelegate:self];
    } else {
        [self.delegate didFailToLoadAd:(ANADRESPONSECODE)ANAdResponseMediatedSDKUnavailable];
    }
}

#pragma mark ADBannerViewDelegate

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd banner failed to load with error: %@", [error localizedDescription]);
    ANAdResponseCode code = ANAdResponseInternalError;
    
    switch (error.code) {
        case ADErrorUnknown:
            code = ANAdResponseInternalError;
            break;
        case ADErrorServerFailure:
            code = ANAdResponseNetworkError;
            break;
        case ADErrorLoadingThrottled:
            code = ANAdResponseNetworkError;
            break;
        case ADErrorInventoryUnavailable:
            code = ANAdResponseUnableToFill;
            break;
        case ADErrorConfigurationError:
            code = ANAdResponseInternalError;
            break;
        case ADErrorBannerVisibleWithoutContent:
            code = ANAdResponseInternalError;
            break;
        case ADErrorApplicationInactive:
            code = ANAdResponseInternalError;
            break;
        default:
            code = ANAdResponseInternalError;
            break;
    }

	[self.delegate didFailToLoadAd:(ANADRESPONSECODE)code];
}

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"iAd banner will load");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd banner did load");
	[self.delegate didLoadBannerAd:banner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [self.delegate adWasClicked];
    if (willLeave) {
        NSLog(@"iAd banner will leave application");
        [self.delegate willLeaveApplication];
    } else {
        NSLog(@"iAd banner will present");
        [self.delegate willPresentAd];
        [self.delegate didPresentAd];
    }
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [self.delegate willCloseAd];
    [self.delegate didCloseAd];
}

@end
