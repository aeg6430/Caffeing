import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StoreInfoPanel extends StatelessWidget {
  const StoreInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, _) {
        final store = storeViewModel.data;

        if (storeViewModel.status == StoreStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

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
              Text(
                "${store.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("BusinessHours: ${store.businessHours ?? '暫無提供'}"),
              Text("Latitude: ${store.latitude}"),
              Text("Longitude: ${store.longitude}"),
              Text("ID: ${store.storeId}"),
              Text("Address: ${store.address ?? '暫無提供'}"),
              Text("ContactNumber: ${store.contactNumber ?? '暫無提供'}"),
            ],
          ),
        );
      },
    );
  }
}
