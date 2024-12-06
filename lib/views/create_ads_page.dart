import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripify/models/travel_package_model.dart';
import 'package:tripify/view_models/ad_provider.dart';
import 'package:tripify/models/ad_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAdsPage extends StatefulWidget {
  final String travelPackageId;
  final double adsCredit;

  CreateAdsPage({required this.travelPackageId, required this.adsCredit});

  @override
  _CreateAdsPageState createState() => _CreateAdsPageState();
}

class _CreateAdsPageState extends State<CreateAdsPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  TravelPackageModel? _selectedPackage;
  String? _selectedAdType;
  double _totalPrice = 0.0;
  DateTime? _startDate;
  DateTime? _endDate;
  late double currentAdsCredit;

  final Map<String, Map<String, dynamic>> _adPackages = {
    "3 Days": {"duration": 3, "price": 50.0},
    "7 Days": {"duration": 7, "price": 100.0},
    "1 Month": {"duration": 30, "price": 300.0},
  };

  @override
  void initState() {
    super.initState();
    _fetchPackage();
    currentAdsCredit = widget.adsCredit;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchPackage() async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Travel_Packages')
        .doc(widget.travelPackageId) // Use the passed package ID
        .get();

    if (snapshot.exists) {
      setState(() {
        _selectedPackage =
            TravelPackageModel.fromMap(snapshot.data() as Map<String, dynamic>);
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;

        DateTime today = DateTime.now();

        if (_startDate!.year == today.year &&
            _startDate!.month == today.month &&
            _startDate!.day == today.day) {
          _startDate = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            DateTime.now().hour,
            DateTime.now().minute,
          );
        } else {
          // If it's a future date, set it to 12:00 AM
          _startDate = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            0,
            0,
          );
        }

        // If ad type is selected, calculate the end date
        if (_selectedAdType != null) {
          _calculateEndDate();
        }
      });
    }
  }

  void _calculateEndDate() {
    if (_startDate != null && _selectedAdType != null) {
      setState(() {
        _endDate = _startDate!
            .add(Duration(days: _adPackages[_selectedAdType!]!['duration']));
      });
    }
  }

  void _submitAd() async {
    if (_selectedPackage == null ||
        _selectedAdType == null ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.adsCredit >= _totalPrice) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: Color(0xFF9F76F9))),
      );

      Advertisement newAd = Advertisement(
        id: '',
        packageId: widget.travelPackageId,
        adType: _selectedAdType!,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'ongoing',
        createdAt: DateTime.now(),
      );

      await AdProvider().createAdvertisement(newAd, context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Not enough credit for this ad. Please top up your wallet.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ads'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_selectedPackage == null)
            Center(child: CircularProgressIndicator())
          else ...[
            // Display selected package info
            Text(
              'Selected Travel Package: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              _selectedPackage!.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Ad Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedAdType,
              decoration: InputDecoration(
                labelText: 'Ad Type',
                border: OutlineInputBorder(),
              ),
              items: _adPackages.keys
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAdType = value;
                  if (_startDate != null) {
                    _calculateEndDate();
                  }

                  _totalPrice = _adPackages[_selectedAdType!]!['price'];
                });
              },
            ),
            SizedBox(height: 30),

            // Start Date Picker
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              child: Text(
                  _startDate == null
                      ? 'Select Start Date'
                      : 'Start Date: ${DateFormat('dd MMM yyyy').format(_startDate!)}',
                  style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 10),

            // End Date Display
            if (_endDate != null)
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0), // Adjust the padding as needed
                child: Text(
                  'End Date: ${DateFormat('dd MMM yyyy').format(_endDate!)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            // Submit Button
            SizedBox(height: 30),
            Spacer(),

            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Total Price: RM${_totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            ElevatedButton(
              onPressed: _submitAd,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 159, 118, 249),
                padding: EdgeInsets.symmetric(vertical: 8),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Create Ad', style: TextStyle(color: Colors.white)),
            ),
          ],
        ]),
      ),
    );
  }
}
