import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapContent extends StatefulWidget {
  final StoreSummaryResponseModel? selectedStore;
  final List<StoreResponseModel>? storeList;
  final double zoom;

  const MapContent({
    Key? key,
    required this.selectedStore,
    this.storeList,
    this.zoom = 14,
  }) : super(key: key);

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  GoogleMapController? _mapController;
  LatLng? _markerPosition;

  // Default location
  final double defaultLatitude = 25.05291553866105;
  final double defaultLongitude = 121.52035694040113;

  String? _mapStyle;
  bool _isLoading = true;

  BitmapDescriptor? _defaultMarkerIcon;
  BitmapDescriptor? _selectedMarkerIcon;
  String? _selectedMarkerId;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcons();
  }

  void _loadCustomMarkerIcons() async {
    final BitmapDescriptor defaultIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(10, 10)),
      'assets/image/marker_default.png',
    );

    final BitmapDescriptor selectedIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(12, 12)),
      'assets/image/marker_selected.png',
    );

    setState(() {
      _defaultMarkerIcon = defaultIcon;
      _selectedMarkerIcon = selectedIcon;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeMode = Provider.of<AppThemeNotifier>(context).currentThemeMode;
    String styleFile =
        themeMode == ThemeMode.dark
            ? 'assets/map_style_dark.json'
            : 'assets/map_style_light.json';

    DefaultAssetBundle.of(context).loadString(styleFile).then((style) {
      setState(() {
        _mapStyle = style;
        _isLoading = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant MapContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() async {
    final store = widget.selectedStore;

    final latitude = store?.latitude ?? defaultLatitude;
    final longitude = store?.longitude ?? defaultLongitude;

    final newPosition = LatLng(latitude, longitude);

    if (_markerPosition != newPosition) {
      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: widget.zoom),
        ),
      );
      setState(() {
        _markerPosition = newPosition;
      });
    }
  }

  Future<Set<Marker>> _generateMarkers(
    List<StoreResponseModel>? storeList,
  ) async {
    if (storeList == null || storeList.isEmpty) return {};
    return storeList.map((store) {
      return Marker(
        markerId: MarkerId(store.storeId),
        position: LatLng(store.latitude, store.longitude),
        icon:
            _selectedMarkerId == store.storeId
                ? _selectedMarkerIcon ?? BitmapDescriptor.defaultMarker
                : _defaultMarkerIcon ?? BitmapDescriptor.defaultMarker,
        onTap: () {
          setState(() {
            _selectedMarkerId = store.storeId;
            _markerPosition = LatLng(store.latitude, store.longitude);
          });
        },
        infoWindow: InfoWindow(title: store.name, snippet: store.address),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.selectedStore;
    final initialLatitude = store?.latitude ?? defaultLatitude;
    final initialLongitude = store?.longitude ?? defaultLongitude;

    return _isLoading
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                S.of(context).mapInitializing,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )
        : FutureBuilder<Set<Marker>>(
          future: _generateMarkers(widget.storeList),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Loading markers',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    _markerPosition ??
                    LatLng(initialLatitude, initialLongitude),
                zoom: widget.zoom,
              ),
              markers: snapshot.data!,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              style: _mapStyle,
            );
          },
        );
  }
}
