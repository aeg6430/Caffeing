import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:flutter/widgets.dart';

class StoreInfoPanel extends StatelessWidget {
  final StoreResponseModel? store;

  const StoreInfoPanel({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No store selected."),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Store Info",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Name: ${store!.name}"),
          Text("Latitude: ${store!.latitude}"),
          Text("Longitude: ${store!.longitude}"),
          Text("ID: ${store!.storeID}"),
        ],
      ),
    );
  }
}
