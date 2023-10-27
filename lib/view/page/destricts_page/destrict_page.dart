import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:nobetci_eczaneler/product/constant/color_constant.dart';
import 'package:nobetci_eczaneler/product/enum/button_size_enum,.dart';
import 'package:nobetci_eczaneler/view/page/destricts_page/destrict_page_provider.dart';
import 'package:nobetci_eczaneler/view/page/pharmacy_page/pharmacy_page.dart';

class DestrictPage extends ConsumerStatefulWidget {
 final String? desctrictName;
 final String? citytitleName;
 final String? cityName;
 const DestrictPage(
      {super.key,
      required this.desctrictName,
      this.citytitleName,
      this.cityName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DestrictPageState();
}

class _DestrictPageState extends ConsumerState<DestrictPage> {
  final _destrictProvider =
      StateNotifierProvider<DestrictPageNotifier, DestrictPageState>((ref) {
    return DestrictPageNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(_destrictProvider.notifier)
          .fetchDestrictAndLoad(widget.desctrictName ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final destrictList = ref.watch(_destrictProvider).destrictList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.appbarBackgroundColor,
        centerTitle: true,
        title: Text("${widget.citytitleName ?? 'N/A Veriable'} İlçeler"),
      ),
      body: (ref.watch(_destrictProvider).isLoading ?? true)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: destrictList?['rowCount'],
              itemBuilder: (context, index) {
                final items = destrictList?['data'][index];
                return ListTile(
                  title: Text(
                    items['ilceAd'],
                    style: context.textTheme.titleLarge,
                  ),
                  trailing: Icon(
                    Icons.navigate_next_rounded,
                    color: ColorConstant.listPageTrailingIcon,
                    size: ButtonSize.buttonNextNormal.value.toDouble(),
                  ),
                  onTap: () {
                    context.navigateToPage(PharmacyPage(
                      city: widget.cityName,
                      destrictName: items['ilceSlug'],
                      destrictNameTitle: items['ilceAd'],
                    ));
                  },
                );
              },
            ),
    );
  }
}
