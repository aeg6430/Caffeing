import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreClusterModel with ClusterItem {
  final String storeId;
  final String name;
  final LatLng latLng;

  StoreClusterModel({
    required this.storeId,
    required this.name,
    required this.latLng,
  });

  @override
  LatLng get location => latLng;
}
