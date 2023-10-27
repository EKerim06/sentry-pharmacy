import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nobetci_eczaneler/product/constant/string_constant.dart';
import 'package:nobetci_eczaneler/view/page/list_page/list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstant.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListPage());
  }
}
