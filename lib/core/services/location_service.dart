class LocationService {
  static const Map<String, Map<String, List<String>>> gujaratData = {
    'Mehsana': {
      'Mehsana': ['Mehsana City', 'Bhasariya', 'Dediyasan', 'Gela Village'],
      'Kadi': ['Kadi Town', 'Nandasan', 'Budhel', 'Indrad'],
      'Visnagar': ['Visnagar Town', 'Kansarakui', 'Kada', 'Kamala'],
    },
    'Gandhinagar': {
      'Gandhinagar': ['Sector 21', 'Pethapur', 'Adalaj', 'Kudasan'],
      'Kalol': ['Kalol City', 'Saij', 'Pala', 'Dhanaj'],
      'Mansa': ['Mansa Town', 'Itadara', 'Charada', 'Bapu Nagar'],
    },
    'Ahmedabad': {
      'Ahmedabad City': ['Bopal', 'Satellite', 'Maninagar', 'Vastrapur'],
      'Daskroi': ['Bhavda', 'Kuha', 'Aslali', 'Kasindra'],
      'Sanand': ['Sanand City', 'Virochannagar', 'Zamp', 'Nidharad'],
    },
  };

  static List<String> getDistricts() {
    return gujaratData.keys.toList();
  }

  static List<String> getTalukas(String district) {
    if (gujaratData.containsKey(district)) {
      return gujaratData[district]!.keys.toList();
    }
    return [];
  }

  static List<String> getVillages(String district, String taluka) {
    if (gujaratData.containsKey(district) &&
        gujaratData[district]!.containsKey(taluka)) {
      return gujaratData[district]![taluka]!;
    }
    return [];
  }
}
