import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:nobetci_eczaneler/product/constant/string_constant.dart';

import '../../../product/constant/url_constant.dart';

class ListPageNotifier extends StateNotifier<ListPageState> {
  ListPageNotifier() : super(ListPageState());

  Future<Map<String, dynamic>> _fetchVeriables() async {
    final dio = Dio();
    String cityUrl = UrlConstant.allCitiesUrl;

    final response = await dio.get(cityUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      state = state.copyWith(cityList: data);

      return data;
    } else {
      print('All cities data get is error. Error code ${response.statusCode}');
      return {};
    }
  }

  Future<void> _fetchBannerLoad() async {
    BannerAd? _bannerAd;
    bool _isLoaded = false;

    _bannerAd = BannerAd(
      adUnitId: AdString.bannerAndroidId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('$ad loaded.');
          _bannerAd = ad as BannerAd;
          _isLoaded = !_isLoaded;
          state = state.copyWith(
              isAds: AdWidget(
            ad: _bannerAd as BannerAd,
            key: UniqueKey(),
          ));
        },
        onAdFailedToLoad: (ad, err) {
          print('BannerAd failed to load: $err');

          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> fetchAndLoad() async {
    state = state.copyWith(isLoading: true);
    await _fetchVeriables();

    state = state.copyWith(isLoading: false);
  }

  Future<void> fetchAds() async {
    state = state.copyWith(isLoadingAds: true);
    await _fetchBannerLoad();
    state = state.copyWith(isLoadingAds: false);
  }
}

class ListPageState {
  final Map<String, dynamic>? cityList;

  final AdWidget? isAds;

  final bool? isLoadingAds;

  final bool? isLoading;

  ListPageState({
    this.cityList,
    this.isLoading,
    this.isAds,
    this.isLoadingAds,
  });

  ListPageState copyWith({
    Map<String, dynamic>? cityList,
    AdWidget? isAds,
    bool? isLoadingAds,
    bool? isLoading,
  }) {
    return ListPageState(
      cityList: cityList ?? this.cityList,
      isAds: isAds ?? this.isAds,
      isLoadingAds: isLoadingAds ?? this.isLoadingAds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
