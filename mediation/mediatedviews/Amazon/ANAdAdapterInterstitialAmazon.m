/*   Copyright 2014 APPNEXUS INC
 
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

#import "ANAdAdapterInterstitialAmazon.h"

@interface ANAdAdapterInterstitialAmazon ()
@property (nonatomic) AmazonAdInterstitial *amazonInterstitial;
@end

@implementation ANAdAdapterInterstitialAmazon

- (void)requestInterstitialAdWithParameter:(NSString *)parameterString
                                  adUnitId:(NSString *)idString
                       targetingParameters:(ANTargetingParameters *)targetingParameters {
    NSLog(@"Requesting Amazon interstitial");
    [self registerAppKey:idString];
    AmazonAdInterstitial *amazonInterstitial = [AmazonAdInterstitial amazonAdInterstitial];
    amazonInterstitial.delegate = self;
    [amazonInterstitial load:[self adOptionsForTargetingParameters:targetingParameters]];
    self.amazonInterstitial = amazonInterstitial;
}

- (void)presentFromViewController:(UIViewController *)viewController {
    [self.amazonInterstitial presentFromViewController:viewController];
}

- (BOOL)isReady {
    return YES;
}

- (void)interstitialDidLoad:(AmazonAdInterstitial *)interstitial {
    NSLog(@"Amazon interstitial did load");
    [self.delegate didLoadInterstitialAd:self];
}

- (void)interstitialDidFailToLoad:(AmazonAdInterstitial *)interstitial
                        withError:(AmazonAdError *)error {
    NSLog(@"Amazon interstitial did fail to load");
    [self handleAmazonError:error];
}

- (void)interstitialWillPresent:(AmazonAdInterstitial *)interstitial {
    // Do nothing.
}

- (void)interstitialDidPresent:(AmazonAdInterstitial *)interstitial {
    // Do nothing.
}

- (void)interstitialWillDismiss:(AmazonAdInterstitial *)interstitial {
    NSLog(@"Amazon interstitial will dismiss");
    [self.delegate willCloseAd];
}

- (void)interstitialDidDismiss:(AmazonAdInterstitial *)interstitial {
    NSLog(@"Amazon interstitial did dismiss");
    [self.delegate didCloseAd];
}

@end