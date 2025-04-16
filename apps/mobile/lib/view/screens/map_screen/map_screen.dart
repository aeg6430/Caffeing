import 'package:caffeing/models/request/search/search_request_model.dart';
import 'package:caffeing/models/request/store/store_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/view/components/custom_bottom_sheet.dart';
import 'package:caffeing/view/components/map_content.dart';
import 'package:caffeing/view/components/search_bar_widget.dart';
import 'package:caffeing/view/components/store_info_panel.dart';
import 'package:caffeing/view_model/keyword/keyword_view_model.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double latitude = 25.05291553866105;
  double longitude =
      121.52035694040113; // Default location (Zhongshan_District,_Taipei inital position)

  TextEditingController _searchController = TextEditingController();
  late SearchViewModel searchViewModel;
  late KeywordViewModel keywordViewModel;
  late StoreViewModel storeViewModel;
  StoreResponseModel? selectedStore;

  @override
  void initState() {
    super.initState();
    searchViewModel = Provider.of<SearchViewModel>(context, listen: false);
    keywordViewModel = Provider.of<KeywordViewModel>(context, listen: false);
    storeViewModel = Provider.of<StoreViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                /*
              Center(
                child: MapContent(latitude: latitude, longitude: longitude),
              ),*/
                Align(
                  alignment: Alignment.topRight,
                  child: SearchBarWidget(
                    searchViewModel: searchViewModel,
                    keywordViewModel: keywordViewModel,
                    onSelected: (store) async {
                      setState(() {
                        latitude = store.latitude ?? latitude;
                        longitude = store.longitude ?? longitude;
                      });
                      await storeViewModel.getStore(
                        StoreRequestModel(storeId: store.storeId),
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
