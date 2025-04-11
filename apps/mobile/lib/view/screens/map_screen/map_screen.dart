import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/view/components/custom_bottom_sheet.dart';
import 'package:caffeing/view/components/map_content.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: MapContent(latitude: latitude, longitude: longitude),
              ),
              Positioned(
                top: 20.0,
                left: 20.0,
                right: 20.0,
                child: Column(
                  children: [
                    // Search TextField
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Enter Location',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _onSearchPressed,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _onSearchPressed,
                      child: Text('Set Sample Location'),
                    ),
                  ],
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
                  return CustomBottomSheet(scrollController: scrollController);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSearchPressed() {
    double sampleLat = 25.054307690427787; // Sample latitude
    double sampleLng = 121.50936894776244; // Sample longitude
    print('New coordinates: Latitude = $sampleLat, Longitude = $sampleLng');
    setState(() {
      latitude = sampleLat;
      longitude = sampleLng;
    });
  }
}
