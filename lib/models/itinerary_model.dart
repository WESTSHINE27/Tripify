import 'package:tripify/models/itinerary_member_model.dart';
import 'package:tripify/models/itinerary_location_model.dart';
import 'package:tripify/models/itinerary_invite_model.dart';

class DayItinerary {
  final int dayNumber;
  final List<ItineraryLocation> locations;

  DayItinerary({
    required this.dayNumber,
    required this.locations,
  });
}

class Itinerary {
  final String id;
  final String name;
  final DateTime startDate;
  final int numberOfDays;
  final List<ItineraryInvite>? invites;
  final List<ItineraryMember> members;
  final List<DayItinerary> dailyItineraries; // List of locations (latitude, longitude)
  final DateTime createdAt;
  DateTime? updatedAt;

  // Dynamically calculate endDate
  DateTime get endDate => startDate.add(Duration(days: numberOfDays - 1));

  Itinerary({
    required this.id,
    required this.name,
    required this.startDate,
    required this.numberOfDays,
    this.invites,
    required this.members,
    required this.dailyItineraries,
    required this.createdAt,
    this.updatedAt,
  });
}
