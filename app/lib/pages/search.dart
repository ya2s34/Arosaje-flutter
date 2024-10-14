import 'dart:convert';
import 'package:app/pages/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MapController mapController = MapController();
  List<CustomMarker> markers = [];
  TextEditingController _searchController = TextEditingController();
  String? _bottomSheetContent;
  bool _showBottomSheet = false;
  int totalAds = 0; // Champ pour stocker le nombre total d'annonces

  void _calculateTotalAds() {
    totalAds =
        markers.fold<int>(0, (total, marker) => total + marker.annoncesCount);
  }

  void _zoomIn() {
    mapController.move(mapController.center, mapController.zoom + 0.5);
  }

  void _zoomOut() {
    mapController.move(mapController.center, mapController.zoom - 0.5);
  }

  void _searchAddress(String address, int count) async {
    try {
      var locations = await locationFromAddress(address);
      if (locations != null && locations.isNotEmpty) {
        var latLng =
            LatLng(locations.first.latitude, locations.first.longitude);

        if (!markers.any((marker) => marker.annoncesCity == address)) {
          setState(() {
            CustomMarker marker = CustomMarker(
              point: latLng,
              width: 80.0,
              height: 80.0,
              child: Container(
                child:
                    Icon(Icons.yard, color: Color.fromARGB(255, 59, 150, 120)),
              ),
              annoncesCity: address,
              annoncesCount: count,
            );
            markers.add(marker);
            mapController.move(latLng, 15.0);
          });
        } else {
          print('Marker already exists for $address');
        }
      } else {
        print('No location found for $address');
      }
    } catch (e) {
      print('Error searching address: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPostsAndAddMarkers();
  }

  Future<void> _fetchPostsAndAddMarkers() async {
    try {
      List<dynamic> posts = await _fetchPosts();
      _addMarkersFromPosts(posts);
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<List<dynamic>> _fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('userId');
    String? token = prefs.getString('token');

    final url = Uri.parse('http://192.168.190.1:3000/api/posts/non-progress');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Map<String, int> calculatePostsByCity(List<dynamic> posts) {
    Map<String, int> postsByCity = {};

    for (var post in posts) {
      String city = post['location'];
      postsByCity[city] = (postsByCity[city] ?? 0) + 1;
    }

    return postsByCity;
  }

  void _addMarkersFromPosts(List<dynamic> posts) {
    Map<String, int> postsByCity = calculatePostsByCity(posts);

    postsByCity.forEach((city, count) {
      if (!markers.any((marker) => marker.annoncesCity == city)) {
        setState(() {
          _searchAddress(city, count);
        });
      }
    });
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        mapController.move(latLng, 15.0);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    _calculateTotalAds();

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_showBottomSheet) {
                setState(() {
                  _showBottomSheet = false;
                });
              }
            },
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(51.509364, -0.128928),
                zoom: 9.2,
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: markers.map((marker) {
                    return Marker(
                      point: marker.point,
                      width: marker.width,
                      height: marker.height,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _toggleBottomSheetVisibility(marker.annoncesCity);
                          });
                        },
                        child: marker.child,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60.0,
            left: 10.0,
            right: 10.0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) {
                            _searchAddress(value, 0);
                          },
                          textInputAction: TextInputAction.search,
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Rechercher une adresse...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          String searchText = _searchController.text;
                          _searchAddress(searchText, 0);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF3b9678),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'Nombre total d\'annonces : $totalAds',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible:
            !_showBottomSheet, // Masquer le FAB quand le BottomSheet est visible
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.my_location,
                color: Color(0xFF3b9678),
              ),
              onPressed: _getCurrentLocation,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.zoom_in, color: Color(0xFF3b9678)),
              onPressed: _zoomIn,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(Icons.zoom_out, color: Color(0xFF3b9678)),
              onPressed: _zoomOut,
            ),
          ],
        ),
      ),
      bottomSheet: _bottomSheetContent != null
          ? AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showBottomSheet
                  ? MediaQuery.of(context).size.height * 0.7
                  : 0.0,
              child: _buildBottomSheet(_bottomSheetContent!),
            )
          : null,
    );
  }

  Widget _buildBottomSheet(String city) {
    if (!_showBottomSheet) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _showBottomSheet = false;
                    _bottomSheetContent = null;
                  });
                },
              ),
            ],
          ),
          Text(
            'Annonces pour $city',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          FutureBuilder<List<dynamic>>(
            future: _fetchCityAds(city),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var ad = snapshot.data![index];
                      return FutureBuilder<http.Response>(
                        future: fetchImage(ad['image_name']),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (imageSnapshot.hasError) {
                            return Text('Erreur de chargement de l\'image');
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.memory(
                                          imageSnapshot.data!.bodyBytes,
                                          width: 150,
                                          height: 150,
                                        ),
                                        SizedBox(width: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ad['title'] ??
                                                  'Titre non disponible',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ad['description'] ??
                                                  'Description non disponible',
                                            ),
                                            Text(
                                              'Utilisateur: ${ad['user_name']}',
                                            ),
                                            Text(
                                              ad['category'] ??
                                                  'categorie non disponible',
                                            ),
                                            SizedBox(height: 10.0),
                                            Divider(),
                                            SizedBox(height: 10.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/message');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Color(0xFF3b9678),
                                              ),
                                              child: Text('Contacter'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _fetchCityAds(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('userId');
    String? token = prefs.getString('token');

    final url =
        Uri.parse('http://192.168.190.1:3000/api/posts/non-progress/$city');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load city ads');
    }
  }

  Future<http.Response> fetchImage(String imageName) async {
    final String url = 'http://192.168.190.1:3000/api/upload/$imageName';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (error) {
      throw Exception('Failed to load image: $error');
    }
  }

  void _toggleBottomSheetVisibility(String city) {
    setState(() {
      _showBottomSheet = !_showBottomSheet;
      _bottomSheetContent = _showBottomSheet ? city : null;
    });
  }
}

class CustomMarker {
  final LatLng point;
  final double width;
  final double height;
  final Widget child;
  final String annoncesCity;
  final int annoncesCount;

  CustomMarker({
    required this.point,
    required this.width,
    required this.height,
    required this.child,
    required this.annoncesCity,
    required this.annoncesCount,
  });
}
