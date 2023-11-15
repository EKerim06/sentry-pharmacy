// ignore_for_file: prefer_typing_uninitialized_variables, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:kartal/kartal.dart';
import 'package:nobetci_eczaneler/product/constant/color_constant.dart';
import 'package:nobetci_eczaneler/product/constant/string_constant.dart';
import 'package:nobetci_eczaneler/view/page/pharmacy_page/pharmacy_page_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyPage extends ConsumerStatefulWidget {
  final String? city;
  final String? destrictName;
  final String? destrictNameTitle;
  const PharmacyPage({super.key, this.city, this.destrictName, this.destrictNameTitle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends ConsumerState<PharmacyPage> {
  final _pharmacyProvider = StateNotifierProvider<PharmacyPageNotifier, PharmacyPageState>((ref) {
    return PharmacyPageNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(_pharmacyProvider.notifier).fetchPharmacyAndLoad(widget.destrictName ?? 'istanbul', widget.city ?? 'beykoz');
    });
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyList = ref.watch(_pharmacyProvider).pharmacyMap;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.listPageTrailingIcon,
        title: Text('${widget.destrictNameTitle ?? 'N/A veriable'} için Eczaneler'),
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
                        _PhermacyName(items: items),
                        _PharmacyAdress(items: items),
                        _PharmacySemt(semt: semt ?? ''),
                        _PharamcyDirections(items: items),
                        _PharmacyTelephone(items: items),
                        _PharmacyCityAndDestrict(items: items),
                      ],
                    );
                  },
                ),
    );
  }
}

class _PharmacyCityAndDestrict extends StatelessWidget {
  const _PharmacyCityAndDestrict({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyCityAndDestrict, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Sehir'] + ' / ' + items['ilce'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _PharmacyTelephone extends StatelessWidget {
  const _PharmacyTelephone({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacytel, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Telefon'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
      trailing: IconButton(
        onPressed: () {
          launch("tel://${items['Telefon']}");
        },
        icon: const Icon(Icons.call),
      ),
    );
  }
}

class _PharamcyDirections extends StatelessWidget {
  const _PharamcyDirections({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyDirections, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['YolTarifi'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _PharmacySemt extends StatelessWidget {
  final String semt;

  const _PharmacySemt({
    super.key,
    required this.semt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacySemt, style: context.textTheme.titleLarge),
      subtitle: Text(
        // || semt != null
        (semt.isNotEmpty) ? ('Semt Verisi Alınamadı !') : (semt),
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _PhermacyName extends StatelessWidget {
  const _PhermacyName({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyName, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['EczaneAdi'],
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
    );
  }
}

class _PharmacyAdress extends StatelessWidget {
  const _PharmacyAdress({
    super.key,
    required this.items,
  });

  final items;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(StringConstant.pharmacyAdress, style: context.textTheme.titleLarge),
      subtitle: Text(
        items['Adresi'],
        maxLines: 2,
        style: context.textTheme.titleMedium?.copyWith(color: Colors.black),
      ),
      trailing: IconButton(
          onPressed: () {
            MapLauncher.showMarker(
              mapType: MapType.google,
              coords: Coords(
                double.parse(
                  items['latitude'].toString(),
                ),
                double.parse(
                  items['longitude'].toString(),
                ),
              ),
              title: items['EczaneAdi'],
              description: items['Adresi'],
            );
          },
          icon: const Icon(Icons.map_outlined)),
    );
  }
}
