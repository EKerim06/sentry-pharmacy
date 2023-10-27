// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PharmacyPageNotifier extends StateNotifier<PharmacyPageState> {
  PharmacyPageNotifier() : super(PharmacyPageState());

  final _dio = Dio();

  Future<void> _fetchPharmarcy(String destrict, String city) async {
    final String pharmacyUrl =
        'https://www.nosyapi.com/apiv2/pharmacyLink?city=$city&county=$destrict&apikey=7Y5947ZM5UaF6HYpb5m06kDakzjkDVa5xwAPuvCOX7W5QPJBDp76n8dqIc5r';

    final response = await _dio.get(pharmacyUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      state = state.copyWith(pharmacyMap: data);
    } else {
      print('fetch district error.Error code : ${response.statusCode}');
    }
  }

  Future<void> fetchPharmacyAndLoad(String destrict, String city) async {
    state = state.copyWith(isPharmacyLoading: true);
    await _fetchPharmarcy(destrict, city);
    state = state.copyWith(isPharmacyLoading: false);
  }
}

class PharmacyPageState {
  final Map<String, dynamic>? pharmacyMap;
  final bool? isPharmacyLoading;

  PharmacyPageState({this.pharmacyMap, this.isPharmacyLoading});

  PharmacyPageState copyWith({
    Map<String, dynamic>? pharmacyMap,
    bool? isPharmacyLoading,
  }) {
    return PharmacyPageState(
      pharmacyMap: pharmacyMap ?? this.pharmacyMap,
      isPharmacyLoading: isPharmacyLoading ?? this.isPharmacyLoading,
    );
  }
}
