import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {

  Future<InitializationStatus> initilization;

  AdState(this.initilization);

  String get bannerAdUnitId => Platform.isAndroid
     ? 'ca-app-pub-6458093605936692/4381853430'
     : 'ca-app-pub-6458093605936692/4381853430';

  static String get banerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6458093605936692/4381853430';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  BannerAdListener get adListener => _adListener;

  BannerAdListener _adListener = BannerAdListener(
    //onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) => print('Ad failed to load: ${ad.adUnitId}, $error.'),
    //onAdOpened: (ad) => print('Ad opened ${ad.adUnitId}.'),
  );
}
