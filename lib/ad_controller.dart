import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdManager {
  static late BannerAd? _bannerAd;
  static int _adLoadCounter = 0;
  static const int _adLoadLimit = 5; // Set the ad load limit

  static void init() {
    _loadAd();
  }

  static void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
        onAdOpened: (ad) {
          print('Ad opened');
        },
        onAdClosed: (ad) {
          print('Ad closed');
          _loadAd(); // Load another ad after the previous one is closed
        },
      ),
    );
    _bannerAd!.load();
  }

  static bool isAdLoaded() {
    return _bannerAd != null;
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
      _loadAd();
    }
  }
}
