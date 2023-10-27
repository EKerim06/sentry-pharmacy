import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:nobetci_eczaneler/product/constant/color_constant.dart';
import 'package:nobetci_eczaneler/product/constant/string_constant.dart';
import 'package:nobetci_eczaneler/product/enum/button_size_enum,.dart';
import 'package:nobetci_eczaneler/view/page/destricts_page/destrict_page.dart';
import 'package:nobetci_eczaneler/view/page/list_page/list_page_provider.dart';

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  final _listPageProvider =
      StateNotifierProvider<ListPageNotifier, ListPageState>((ref) {
    return ListPageNotifier();
  });

  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(_listPageProvider.notifier).fetchAndLoad());
  }

  @override
  Widget build(BuildContext context) {
    final liste = ref.watch(_listPageProvider).cityList;
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstant.appName),
        centerTitle: true,
        backgroundColor: ColorConstant.appbarBackgroundColor,
      ),
      body: (ref.watch(_listPageProvider).isLoading ?? true)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: ref.watch(_listPageProvider).cityList?['rowCount'],
              itemBuilder: (context, index) {
                final list = liste?['data'];
                return ListTile(
                  onTap: () {
                    final String? desctrictName = list[index]['SehirSlug'];
                    myNavigateToPage(context, desctrictName, list, index);
                  },
                  title: Text(list[index]['SehirAd'],
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                      )),
                  trailing: Icon(
                    Icons.navigate_next_outlined,
                    color: ColorConstant.listPageTrailingIcon,
                    size: ButtonSize.buttonNextNormal.value.toDouble(),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox();
/*                 int yeniindex = index + 1;
                if (yeniindex % 80 == 0) {
                  Future.microtask(
                      () => ref.read(_listPageProvider.notifier).fetchAds());
                  if (ref.watch(_listPageProvider).isAds != null &&
                      ref.watch(_listPageProvider).isLoadingAds == false) {
                    return SizedBox(
                      width: context.width,
                      height: 120,
                      child: ref.watch(_listPageProvider).isAds,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
                return const SizedBox(); */
              },
            ),
    );
  }

  Future<Object?> myNavigateToPage(
      BuildContext context, String? desctrictName, list, int index) {
    return context.navigateToPage(
        DestrictPage(
            desctrictName: desctrictName,
            citytitleName: list[index]['SehirAd'],
            cityName: list[index]['SehirSlug']),
        type: SlideType.LEFT);
  }
}
