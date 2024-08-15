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
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/8691691433';
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
         
        },
        onAdFailedToLoad: (ad, error) {
         
          ad.dispose();
          _bannerAd = null;
        },
        onAdOpened: (ad) {
         
        },
        onAdClosed: (ad) {
         
          _loadBannerAd(); 
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
          
        },
        onAdFailedToLoad: (ad, error) {
        
          ad.dispose();
          _secondaryBannerAd = null;
        },
        onAdOpened: (ad) {
        
        },
        onAdClosed: (ad) {
        
          _loadSecondaryBannerAd(); 
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
         
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
       
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
        
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
         
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
        
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
         
        },
      ),
     
    );
  }

  static void showAppOpenAd() async {
    if (_appOpenAd != null) {
      await _appOpenAd!.show();
      _appOpenAd = null; 
      _loadAppOpenAd(); 
    } else {
     
      _loadAppOpenAd();
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
     
      _loadInterstitialAd(); 
    }
  }

  static void showRewardedAd() async {
    if (_rewardedAd != null) {
      try {
        await _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          
          },
        );
      } catch (e) {
      
        _loadRewardedAd(); 
      }
    } else {
    
      _loadRewardedAd(); 
    }
  }
}
