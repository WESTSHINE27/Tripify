import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripify/models/new_travel_package_model.dart';
import 'package:tripify/models/travel_package_model.dart';
import 'package:tripify/view_models/firestore_service.dart';
import 'package:tripify/views/ad_wallet_page.dart';
import 'package:tripify/widgets/travel_packages_on_shelves_card_list.dart';

class TravelPackageOnShelvesRepoPage extends StatefulWidget {
  final int adsCredit;

  TravelPackageOnShelvesRepoPage({required this.adsCredit});

  @override
  _TravelPackageOnShelvesRepoPageState createState() =>
      _TravelPackageOnShelvesRepoPageState();
}

class _TravelPackageOnShelvesRepoPageState
    extends State<TravelPackageOnShelvesRepoPage> {
  FirestoreService _firestoreService = FirestoreService();
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  int adsCredit = 0;
  int walletBalance = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchWalletBal();
    // walletBalance = widget.adsCredit;
    // _startWalletBalanceFetcher();
  }

  // void _startWalletBalanceFetcher() {
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     _fetchWalletBal();
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  Future<void> _fetchWalletBal() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          walletBalance = (userDoc['ads_credit'] ?? 0).toInt();
        });
      } else {
        setState(() {
          walletBalance = 0;
        });
      }
    } catch (e) {
      // Handle potential errors
      setState(() {
        walletBalance = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travel Packages On Shelves",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WalletPage(walletBalance: widget.adsCredit),
                ),
              ).then((result) {
                if (result != null && result) {
                  _fetchWalletBal();
                }
              });
            },
            icon: Icon(Icons.account_balance_wallet),
            label: Text(
              'RM${walletBalance.toStringAsFixed(2)}',
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getStreamDataByTwoField(
          collection: 'New_Travel_Packages',
          field: 'created_by',
          value: currentUserId,
          field2: 'is_resale',
          value2: false,
          orderBy: 'created_at', // Assuming you have a `created_at` field
          descending: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No travel packages found on shelves."),
            );
          }

          List<NewTravelPackageModel> travelPackagesOnShelvesList = snapshot
              .data!.docs
              .map((doc) => NewTravelPackageModel.fromMap(
                  doc.data() as Map<String, dynamic>))
              .toList();

          return TravelPackageOnShelvesCardList(
            travelPackagesOnShelvesList: travelPackagesOnShelvesList,
            currentUserId: currentUserId,
          );
        },
      ),
    );
  }
}
