// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DestrictPageNotifier extends StateNotifier<DestrictPageState> {
  DestrictPageNotifier() : super(DestrictPageState());
  final _dio = Dio();

  Future<void> _fetchDestrcict(String destrict) async {
    String destrictUrl =
        'https://www.nosyapi.com/apiv2/pharmacy/city?city=$destrict&apikey=7Y5947ZM5UaF6HYpb5m06kDakzjkDVa5xwAPuvCOX7W5QPJBDp76n8dqIc5r';

    final response = await _dio.get(destrictUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      state = state.copyWith(destrictList: data);
    } else {
      print('Destrict fecth error. Error code ${response.statusCode}');
    }
  }

  Future<void> fetchDestrictAndLoad(String destrict) async {
    state = state.copyWith(isLoading: true);
    await _fetchDestrcict(destrict);
    state = state.copyWith(isLoading: false);
  }


}

class DestrictPageState {
  final Map<String, dynamic>? destrictList;
  final bool? isLoading;


  DestrictPageState(
      {
      this.destrictList,
      this.isLoading});

  DestrictPageState copyWith(
      {Map<String, dynamic>? destrictList,
      bool? isLoading,
      Map<String, dynamic>? pharmacyList,
      bool? isPharmacyLoading}) {
    return DestrictPageState(
      destrictList: destrictList ?? this.destrictList,
      isLoading: isLoading ?? this.isLoading,
 
    );
  }
}
