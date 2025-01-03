// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart'; // Import shimmer package
// import 'package:tripify/models/travel_package_model.dart';
// import 'package:tripify/models/travel_package_purchased_model.dart';
// import 'package:tripify/models/user_model.dart';
// import 'package:tripify/view_models/firestore_service.dart';
// import 'package:tripify/views/travel_package_details_page.dart';

// class TravelPackageOnShelvesCard extends StatefulWidget {
//   final TravelPackageModel travelPackageOnShelve;
//   final String currentUserId;

//   const TravelPackageOnShelvesCard(
//       {super.key,
//       required this.travelPackageOnShelve,
//       required this.currentUserId});

//   @override
//   _TravelPackagePurchasedCardState createState() =>
//       _TravelPackagePurchasedCardState();
// }

// class _TravelPackagePurchasedCardState
//     extends State<TravelPackageOnShelvesCard> {
//   FirestoreService _firestoreService = FirestoreService();
//   TravelPackageModel? travelPackage;
//   bool showMore = false; // State to control visibility of the last row
//   int? viewNum;
//   int? clickNum;
//   int? saveNum;
//   double? purchaseRate;
//     UserModel? travelCompanyUser;


//   @override
//   void initState() {
//     travelPackage = widget.travelPackageOnShelve;
//     fetchTravelCompany;
//     super.initState();
//   }



//   void fetchTravelCompany() async {
//     Map<String, dynamic>? userMap;
//     userMap = await _firestoreService.getDataById(
//         'User', widget.travelPackageOnShelve.createdBy);

//     setState(() {
//       if (userMap != null) {
//         travelCompanyUser = UserModel.fromMap(userMap, userMap['id']);
//         print(travelCompanyUser);
        
//       }
//     });
//   }



//   @override
//   Widget build(BuildContext context) {
//     viewNum = widget.travelPackageOnShelve.viewNum?.length;
//     clickNum = widget.travelPackageOnShelve.clickNum?.length;
//     saveNum = widget.travelPackageOnShelve.saveNum?.length;
//     if (clickNum != null) {
//       purchaseRate = (widget.travelPackageOnShelve.quantity -
//               widget.travelPackageOnShelve.quantityAvailable) /
//           clickNum!;
//       purchaseRate = double.parse(purchaseRate!.toStringAsFixed(2));
//     }
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TravelPackageDetailsPage(
//               travelPackage: travelPackage!,
//               currentUserId: widget.currentUserId,
//               travelPackageUser: travelCompanyUser!,
//             ),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12.0),
//                 topRight: Radius.circular(12.0),
//               ),
//               child: Container(
//                 height: 150,
//                 width: double.infinity,
//                 child: CarouselSlider.builder(
//                   itemCount: travelPackage!.images!.length,
//                   options: CarouselOptions(
//                     viewportFraction: 1,
//                     autoPlay: true,
//                     enableInfiniteScroll: false,
//                   ),
//                   itemBuilder: (ctx, index, realIdx) {
//                     return Stack(
//                       children: [
//                         Positioned.fill(
//                           child: Shimmer.fromColors(
//                             baseColor: Colors.grey[300]!,
//                             highlightColor: Colors.grey[100]!,
//                             child: Container(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Image.network(
//                           travelPackage?.images?[index] ?? '',
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) {
//                               return child;
//                             }
//                             return Shimmer.fromColors(
//                               baseColor: Colors.grey[300]!,
//                               highlightColor: Colors.grey[100]!,
//                               child: Container(
//                                 color: Colors.white,
//                                 height: 150,
//                                 width: double.infinity,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) => Icon(
//                             Icons.broken_image,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               travelPackage?.name ?? 'Loading...',
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             Text(
//                                 '${DateFormat('yyyy-MM-dd').format(travelPackage!.startDate)} - ${DateFormat('yyyy-MM-dd').format(travelPackage!.endDate)}'),
//                             const SizedBox(height: 5),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         travelPackage!.price.toString(),
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.remove_red_eye),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(viewNum != null ? '$viewNum' : '0'),
//                       Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           if (widget.travelPackageOnShelve.quantity !=
//                               widget.travelPackageOnShelve.quantityAvailable) {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: const Text('Error'),
//                                   content: const Text(
//                                       'You delete the travel package that already have user purchased!'),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context)
//                                             .pop(); // Close the dialog
//                                       },
//                                       child: const Text('OK'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           } else {
//                             _showDeleteDialog(context);
//                           }
//                         },
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 12),
//                         ),
//                         child: const Text('Delete'),
//                       )
//                     ],
//                   ),
//                   Visibility(
//                       visible: showMore, // Show row only if `showMore` is true
//                       child: Table(
//                         columnWidths: const {
//                           0: FlexColumnWidth(
//                               1), // Own column takes 1/3 of the width
//                           1: FlexColumnWidth(
//                               1), // Available column takes 1/3 of the width
//                           2: FlexColumnWidth(
//                               1), // Sold column takes 1/3 of the width
//                         },
//                         border: TableBorder(
//                           top: BorderSide(color: Colors.grey, width: 0.5),
//                           left: BorderSide.none,
//                           right: BorderSide.none,
//                           horizontalInside:
//                               BorderSide.none, // For no borders between rows
//                           verticalInside:
//                               BorderSide.none, // For no borders between columns
//                         ),
//                         children: [
//                           TableRow(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Own: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             '${widget.travelPackageOnShelve.quantity}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Available: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             '${widget.travelPackageOnShelve.quantityAvailable}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Sold: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             '${widget.travelPackageOnShelve.quantity - widget.travelPackageOnShelve.quantityAvailable}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           TableRow(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'CTR: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             '${widget.travelPackageOnShelve.quantity - widget.travelPackageOnShelve.quantityAvailable}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'PR: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: '${purchaseRate}%',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: RichText(
//                                   textAlign: TextAlign.center,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Save: ',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .bold, // Bold for "Sold:"
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: '${saveNum}',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight
//                                               .normal, // Normal for the number
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         showMore = !showMore; // Toggle `showMore` state
//                       });
//                     },
//                     child: Text(showMore ? 'Show Less' : 'Show More'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     TextEditingController priceController = TextEditingController();
//     final _formKey = GlobalKey<FormBuilderState>();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Confirmation'),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return FormBuilder(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       'Are you sure to delete ${widget.travelPackageOnShelve.name} Travel Package?',
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await _firestoreService.deleteData(
//                     'Travel_Packages', widget.travelPackageOnShelve.id);
//                 await _firestoreService.deleteData(
//                     'Conversations', widget.travelPackageOnShelve.groupChatId!);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Confirm'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
