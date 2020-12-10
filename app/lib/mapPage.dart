import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';
import 'package:app/home_page.dart';

class MapPage extends StatefulWidget {
  final String title;
  LatLng latLng;

  MapPage({
    Key key,
    this.title,
    this.latLng,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng centre;
  String locality;

  @override
  Widget build(BuildContext context) {
    _updateLocationOneTime();
    return buildMap(centre);
  }

  void _updateLocationOneTime() {
    print('update location');
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position userLocation) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userLocation.latitude, userLocation.longitude);
      centre = LatLng(userLocation.latitude, userLocation.longitude);
      locality = placemarks[0].locality;
      print("Build map centred at: $centre");
      buildMap(centre);
    });
  }

  Scaffold buildMap(LatLng centre) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(locality);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          minZoom: 13.0,
          center: centre,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/stefc97/ckiffc7l22r921an3sen88g6t/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3RlZmM5NyIsImEiOiJja2lmZHNrNG8xanR6MnlsNjc4eHd4Nm41In0._59tBxuso2VhcXmY9ySJow',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoic3RlZmM5NyIsImEiOiJja2lmZHNrNG8xanR6MnlsNjc4eHd4Nm41In0._59tBxuso2VhcXmY9ySJow',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          MarkerLayerOptions(markers: [
            Marker(
              width: 45.0,
              height: 45.0,
              point: centre,
              builder: (context) => Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.blue,
                  iconSize: 45.0,
                  onPressed: () {
                    print('Marker clicked');
                  },
                ),
              ),
            ),
          ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateLocationOneTime,
        tooltip: 'Update',
        child: Icon(Icons.update),
      ),
    );
  }
}
