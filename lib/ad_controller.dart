import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



class AdManager {
  static late BannerAd? _bannerAd;
  static late InterstitialAd? _interstitialAd;
  static late RewardedAd? _rewardedAd;

  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; 
  static int _adLoadCounter = 0;
  static const int _adLoadLimit = 5; // Set the ad load limit

  static void init() {
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  static void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
        onAdOpened: (ad) {
          print('Banner ad opened');
        },
        onAdClosed: (ad) {
          print('Banner ad closed');
          _loadBannerAd(); // Load another ad after the previous one is closed
        },
      ),
    );
    _bannerAd!.load();
  }

  static void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Interstitial ad loaded');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  static void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print('Rewarded ad loaded');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  static bool isBannerAdLoaded() {
    return _bannerAd != null;
  }

  static bool isInterstitialAdLoaded() {
    return _interstitialAd != null;
  }

  static bool isRewardedAdLoaded() {
    return _rewardedAd != null;
  }

  static Widget? getBannerAdWidget() {
    if (_bannerAd != null) {
      return AdWidget(ad: _bannerAd!);
    } else {
      return null;
    }
  }

  static void incrementAdLoadCounter() {
    _adLoadCounter++;
    if (_adLoadCounter >= _adLoadLimit) {
      _adLoadCounter = 0;
      _loadBannerAd();
    }
  }

  static void showInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
    } else {
      print('Interstitial ad is not ready yet');
      _loadInterstitialAd(); // Load the interstitial ad if it's not initialized
    }
  }

 static void showRewardedAd() async {
  if (_rewardedAd != null) {
    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // Handle reward logic here
        },
      );
    } catch (e) {
      print('Failed to show rewarded ad: $e');
      _loadRewardedAd(); // Load another rewarded ad if the current one fails
    }
  } else {
    print('Rewarded ad is not ready yet');
    _loadRewardedAd(); // Load the rewarded ad if it's not initialized
  }
}
}
