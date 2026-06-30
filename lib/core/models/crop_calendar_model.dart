class CropCalendarModel {
  final String id;
  final String cropName;
  final String stage;
  final String recommendedDates;
  final String status; // e.g., Ideal, Planning
  final String season;
  final String sowingPeriod;
  final String duration;
  final String harvestPeriod;
  final String bestSoil;
  final String waterRequirement;
  final String description;

  CropCalendarModel({
    required this.id,
    required this.cropName,
    required this.stage,
    required this.recommendedDates,
    required this.status,
    required this.season,
    required this.sowingPeriod,
    required this.duration,
    required this.harvestPeriod,
    required this.bestSoil,
    required this.waterRequirement,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'stage': stage,
      'recommendedDates': recommendedDates,
      'status': status,
      'season': season,
      'sowingPeriod': sowingPeriod,
      'duration': duration,
      'harvestPeriod': harvestPeriod,
      'bestSoil': bestSoil,
      'waterRequirement': waterRequirement,
      'description': description,
    };
  }

  factory CropCalendarModel.fromMap(Map<String, dynamic> map) {
    return CropCalendarModel(
      id: map['id'].toString(),
      cropName: map['crop_name'] ?? map['cropName'] ?? '',
      stage: map['current_stage'] ?? map['stage'] ?? '',
      recommendedDates: map['recommended_dates'] ?? map['recommendedDates'] ?? '',
      status: map['current_status'] ?? map['status'] ?? '',
      season: map['season'] ?? '',
      sowingPeriod: map['sowing_period'] ?? map['sowingPeriod'] ?? '',
      duration: map['duration'] ?? '',
      harvestPeriod: map['harvest_period'] ?? map['harvestPeriod'] ?? '',
      bestSoil: map['best_soil'] ?? map['bestSoil'] ?? '',
      waterRequirement: map['water_requirement'] ?? map['waterRequirement'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
