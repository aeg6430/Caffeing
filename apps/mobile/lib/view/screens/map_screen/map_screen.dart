import 'package:caffeing/models/request/store/store_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/provider/locale_provider.dart';
import 'package:caffeing/view/components/custom_bottom_sheet.dart';
import 'package:caffeing/view/components/map_content.dart';
import 'package:caffeing/view/components/search_bar_widget.dart';
import 'package:caffeing/view/components/store_info_panel.dart';
import 'package:caffeing/view_model/keyword/keyword_view_model.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:caffeing/view_model/map/map_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    final storeVM = Provider.of<StoreViewModel>(context, listen: false);
    final mapVM = Provider.of<MapViewModel>(context, listen: false);

    storeVM.getAllStore().then((_) {
      mapVM.updateMapStores(storeVM.storeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // Use Selector to only rebuild mapContent when mapStores changes
                Selector<MapViewModel, List<StoreResponseModel>>(
                  selector: (context, mapVM) => mapVM.mapStores,
                  builder: (context, mapStores, _) {
                    return Consumer2<StoreViewModel, MapViewModel>(
                      builder: (context, storeVM, mapVM, _) {
                        return Center(
                          child: MapContent(
                            storeList: mapStores,
                            onStoreSelected: (store) async {
                              mapVM.updateSelectedStore(store);
                              await storeVM.getStoreByRequest(
                                StoreRequestModel(storeId: store.storeId),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer4<
                    SearchViewModel,
                    KeywordViewModel,
                    MapViewModel,
                    StoreViewModel
                  >(
                    builder: (context, searchVM, keywordVM, mapVM, storeVM, _) {
                      return SearchBarWidget(
                        searchViewModel: searchVM,
                        keywordViewModel: keywordVM,
                        onSelected: (store) async {
                          mapVM.updateSelectedStore(store);
                          await storeVM.getStoreByRequest(
                            StoreRequestModel(storeId: store.storeId),
                          );
                        },
                      );
                    },
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.25,
                  minChildSize: 0.1,
                  maxChildSize: 0.8,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    return CustomBottomSheet(
                      scrollController: scrollController,
                      child: StoreInfoPanel(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
