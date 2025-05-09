import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LocationAutoComplete extends StatefulWidget {
  final TextEditingController controller;

  const LocationAutoComplete({super.key, required this.controller});

  @override
  State<LocationAutoComplete> createState() => _LocationAutoCompleteState();
}
class _LocationAutoCompleteState extends State<LocationAutoComplete> {
  String _sessionToken = '';
  var uuid = const Uuid();
  List<dynamic> listOfLocation = [];
  Timer? _debounce;
  int _selectedIndex = 0;
  bool _locationSelected = false; // Track if a location has been selected

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
    _sessionToken = uuid.v4();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    if (_locationSelected) {
      return; // Don't fetch new predictions if a location was already selected
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.controller.text.isNotEmpty) {
        placeSuggestion(widget.controller.text);
      } else {
        setState(() {
          listOfLocation = [];
        });
      }
    });
  }

  void placeSuggestion(String input) async {
    String mapsApiKey = dotenv.env["GOOGLE_MAPS_API_KEY"]!;

    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request =
          '$baseUrl?input=$input&key=$mapsApiKey&sessiontoken=$_sessionToken';

      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          listOfLocation = json.decode(response.body)['predictions'];
          _selectedIndex = 0;
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void _selectLocation(String description) {
    widget.controller.text = description;
    setState(() {
      listOfLocation = [];
      _locationSelected = true; // Mark that a location has been selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            _locationSelected = false; // Allow predictions again on focus
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: "Enter location",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            onFieldSubmitted: (value) {
              if (listOfLocation.isNotEmpty) {
                _selectLocation(listOfLocation[_selectedIndex]['description']);
              }
            },
          ),
          const SizedBox(height: 8.0),
          if (listOfLocation.isNotEmpty && !_locationSelected)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listOfLocation.length,
                itemBuilder: (context, index) {
                  final location = listOfLocation[index];
                  return GestureDetector(
                    onTap: () => _selectLocation(location['description']),
                    child: Container(
                      color: _selectedIndex == index
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                      child: ListTile(
                        title: Text(location['description']),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}