import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';




class AdManager {
  static BannerAd? _bannerAd;
  static BannerAd? _secondaryBannerAd;
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static AppOpenAd? _appOpenAd;

  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String secondaryBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; 
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String appOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921'; 

  static void init() {
    _loadBannerAd();
    _loadSecondaryBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
    _loadAppOpenAd();
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

  static void _loadSecondaryBannerAd() {
    _secondaryBannerAd = BannerAd(
      adUnitId: secondaryBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Secondary banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Secondary banner ad failed to load: $error');
          ad.dispose();
          _secondaryBannerAd = null;
        },
        onAdOpened: (ad) {
          print('Secondary banner ad opened');
        },
        onAdClosed: (ad) {
          print('Secondary banner ad closed');
          _loadSecondaryBannerAd(); // Load another ad after the previous one is closed
        },
      ),
    );
    _secondaryBannerAd!.load();
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

  static void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('App open ad loaded');
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('App open ad failed to load: $error');
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  static void showAppOpenAd() async {
    if (_appOpenAd != null) {
      await _appOpenAd!.show();
      _appOpenAd = null; // Reset the ad to ensure it doesn't show again
      _loadAppOpenAd(); // Load another ad for the next app open event
    } else {
      print('App open ad is not ready yet');
      _loadAppOpenAd(); // Load the app open ad if it's not initialized
    }
  }

  static bool isBannerAdLoaded() {
    return _bannerAd != null;
  }

  static bool isSecondaryBannerAdLoaded() {
    return _secondaryBannerAd != null;
  }

  static bool isInterstitialAdLoaded() {
    return _interstitialAd != null;
  }

  static bool isRewardedAdLoaded() {
    return _rewardedAd != null;
  }

  static bool isAppOpenAdLoaded() {
    return _appOpenAd != null;
  }

  static BannerAd? get secondaryBannerAd => _secondaryBannerAd;

  static Widget? getBannerAdWidget() {
    if (_bannerAd != null) {
      return AdWidget(ad: _bannerAd!);
    } else {
      return null;
    }
  }

  static Widget? getSecondaryBannerAdWidget() {
    if (_secondaryBannerAd != null) {
      return AdWidget(ad: _secondaryBannerAd!);
    } else {
      return null;
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
