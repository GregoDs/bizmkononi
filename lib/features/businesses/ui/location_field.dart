import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../../exports.dart';

class LocationAutoComplete extends StatefulWidget {
  final TextEditingController controller;
  final FormValidationCubit formValidationCubit;
  final String fieldId;

  const LocationAutoComplete({
    super.key, 
    required this.controller,
    required this.formValidationCubit,
    required this.fieldId,
  });

  @override
  State<LocationAutoComplete> createState() => _LocationAutoCompleteState();
}

class _LocationAutoCompleteState extends State<LocationAutoComplete> {
  String _sessionToken = '';
  var uuid = const Uuid();
  List<dynamic> listOfLocation = [];
  Timer? _debounce;
  int _selectedIndex = 0;
  bool _locationSelected = false;
  bool _isLoading = false;
  final Map<String, List<dynamic>> _cache = {};
  final _httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
    _sessionToken = uuid.v4();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _debounce?.cancel();
    _httpClient.close();
    super.dispose();
  }

  void _onChange() {
    if (_locationSelected) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (widget.controller.text.isNotEmpty) {
        placeSuggestion(widget.controller.text);
      } else {
        setState(() {
          listOfLocation = [];
          _isLoading = false;
        });
      }
    });
    
    widget.formValidationCubit.validateField(
      widget.fieldId,
      widget.controller.text.isNotEmpty,
    );
  }

  void placeSuggestion(String input) async {
    // Check cache first
    if (_cache.containsKey(input)) {
      setState(() {
        listOfLocation = _cache[input]!;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String mapsApiKey = dotenv.env["GOOGLE_MAPS_API_KEY"]!;

    try {
      String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request = '$baseUrl?input=$input&key=$mapsApiKey&sessiontoken=$_sessionToken&types=geocode';

      var response = await _httpClient.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final predictions = json.decode(response.body)['predictions'] as List;
        // Cache the results
        _cache[input] = predictions;
        
        if (mounted) {
          setState(() {
            listOfLocation = predictions;
            _selectedIndex = 0;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectLocation(String description) {
    widget.controller.text = description;
    setState(() {
      listOfLocation = [];
      _locationSelected = true;
    });
    widget.formValidationCubit.validateField(widget.fieldId, true);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            _locationSelected = false;
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
              hintStyle: TextStyle(
                color: ColorName.mainGrey,
                fontSize: 14.sp,
                fontFamily: FontFamily.lato,
              ),
              filled: true,
              fillColor: ColorName.textfieldColor,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ColorName.lightGrey,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ColorName.lightGrey,
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
              suffixIcon: _isLoading 
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : null,
            ),
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: ColorName.blackColor,
              fontSize: 16.sp,
            ),
            onFieldSubmitted: (value) {
              if (listOfLocation.isNotEmpty) {
                _selectLocation(listOfLocation[_selectedIndex]['description']);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          if (listOfLocation.isNotEmpty && !_locationSelected)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ConstrainedBox(
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
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? ColorName.blue200.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            location['description'],
                            style: TextStyle(
                              color: ColorName.blackColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}