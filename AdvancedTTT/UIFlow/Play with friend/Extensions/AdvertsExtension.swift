//
//  AdvertsExtension.swift
//  AdvancedTTT
//
//  Created by User on 30.01.2022.
//

import UIKit
import GoogleMobileAds


//MARK: - GADFullScreenContentDelegate
extension GameViewController: GADFullScreenContentDelegate {
    
    func loadAdvertIfNeeded(isNeed: Bool) {
        if !isNeed { return }
        
        let request = GADRequest()
        //ca-app-pub-9391157593798156/5924690659
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910", request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                print("§ Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            print("§ success")
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("§ Ad did fail to present full screen content.")
        viewModel.reloadGame()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("§ Ad did dismiss full screen content.")
        viewModel.reloadGame()
    }
}
