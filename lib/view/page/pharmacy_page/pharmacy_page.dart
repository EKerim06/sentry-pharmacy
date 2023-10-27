// ignore_for_file: prefer_typing_uninitialized_variables, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:nobetci_eczaneler/product/constant/color_constant.dart';
import 'package:nobetci_eczaneler/product/constant/string_constant.dart';
import 'package:nobetci_eczaneler/view/page/pharmacy_page/pharmacy_page_provider.dart';

class PharmacyPage extends ConsumerStatefulWidget {
  final String? city;
  final String? destrictName;
  final String? destrictNameTitle;
  const PharmacyPage(
      {super.key, this.city, this.destrictName, this.destrictNameTitle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends ConsumerState<PharmacyPage> {
  final _pharmacyProvider =
      StateNotifierProvider<PharmacyPageNotifier, PharmacyPageState>((ref) {
    return PharmacyPageNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(_pharmacyProvider.notifier).fetchPharmacyAndLoad(
          widget.destrictName ?? 'istanbul', widget.city ?? 'beykoz');
    });
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyList = ref.watch(_pharmacyProvider).pharmacyMap;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.listPageTrailingIcon,
        title: Text(
            '${widget.destrictNameTitle ?? 'N/A veriable'} için Eczaneler'),
      ),
      body: (ref.watch(_pharmacyProvider).isPharmacyLoading ?? true)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (pharmacyList?['rowCount'] ?? 0) == 0
              ? Padding(
                  padding: context.paddingLow,
                  child: Center(
                      child: Text(
                    StringConstant.zeroPharmacyCount,
                    style: context.textTheme.titleLarge,
                  )),
                )
              : ListView.builder(
                  itemCount: pharmacyList?['rowCount'] ?? 0,
                  itemBuilder: (context, index) {
                    final items = pharmacyList?['data'][index];
                    final String? semt = items['Semt'];
                    return ExpansionTile(
                      title: Text(
                        items['EczaneAdi'],
                        style: context.textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        items['Adresi'],
                        style: context.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      children: [
                        _phermacyName(items: items),
                        _pharmacyAdress(items: items),
                        _pharmacySemt(semt: semt ?? ''),
                        _pharamcyDirections(items: items),
                        _pharmacyTelephone(items: items),
                        _pharmacyCityAndDestrict(items: items),
                      ],
                    );
                  },
                ),
    );
  }
}

class _pharmacyCityAndDestrict extends StatelessWidget {
  const _pharmacyCityAndDestrict({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyCityAndDestrict,
          style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Sehir'] + ' / ' + items['ilce'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class  _pharmacyTelephone extends StatelessWidget {
  const _pharmacyTelephone({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(StringConstant.pharmacytel, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Telefon'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _pharamcyDirections extends StatelessWidget {
  const _pharamcyDirections({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyDirections,
          style: context.textTheme.titleLarge),
      subtitle: Text(
        items['YolTarifi'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _pharmacySemt extends StatelessWidget {
  final String semt;

  const _pharmacySemt({
    super.key,
    required this.semt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacySemt,
          style: context.textTheme.titleLarge),
      subtitle: Text(
        // || semt != null
        (semt.isNotEmpty) ? ('Semt Verisi Alınamadı !') : (semt),
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _phermacyName extends StatelessWidget {
  const _phermacyName({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyName,
          style: context.textTheme.titleLarge),
      subtitle: Text(
        items['EczaneAdi'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _pharmacyAdress extends StatelessWidget {
  const _pharmacyAdress({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyAdress,
          style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Adresi'],
        maxLines: 2,
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}
