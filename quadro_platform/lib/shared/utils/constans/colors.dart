import 'package:flutter/material.dart';

import '../../enum/maitenance_request_status.dart';
import 'helper_functions.dart';

class Qcolors {
  static const Color primarycolor = Color(0xff0288a6);
  static const Color secondary = Color(0xFF05AB9F);
  static const Color blackFont = Color(0xff121212);
  static const Color info = Color(0xFF03A9F4);
  static const Color buttonbackground = Color(0xFFE4F4F7);
  static const Color warning = Color(0xFFFFC107);
  static const Color success = Color(0xFF4CAF50); // Green
  static Color getCurrentColor(BuildContext context) {
    final isDark = QhelperFucntions.isDarkMode(context);
    return isDark
        ? const Color(0xFF1A2A38)
        : const Color.fromARGB(255, 210, 237, 242);
  }

  static Color getPrimeryColor(BuildContext context) {
    final isDark = QhelperFucntions.isDarkMode(context);
    return isDark
        ? const Color(0xFF1A2A38)
        : const Color.fromARGB(255, 220, 246, 244);
  }

  static List<Color> gradient = [
    const Color(0xFF0078A3),
    const Color(0xFF03AABF),
    const Color(0xFF0EDED2),
  ];
  static Color getColorForRequestType(RequestType requestType) {
    switch (requestType) {
      case RequestType.vehicle_owner_id:
        return Qcolors.secondary;
      case RequestType.workshop_id:
        return Qcolors.primarycolor;
    }
  }

  static Color getLightColorForRequestType(
      RequestType requestType, BuildContext context) {
    switch (requestType) {
      case RequestType.vehicle_owner_id:
        return getPrimeryColor(context);
      case RequestType.workshop_id:
        return getCurrentColor(context);
    }
  }

  static String getMapTheme(BuildContext context) {
    final isDark = QhelperFucntions.isDarkMode(context);
    if (isDark) {
      return darkMapStyle;
    } else {
      return lightMapStyle;
    }
  }

// Dark mode map style (JSON)
  static const String darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#263c3f"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6b9a76"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#38414e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#212a37"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9ca5b3"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#1f2835"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#f3d19c"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2f3948"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#515c6d"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    }
  ]
  ''';
  // Customized Light Mode Map Style (JSON)
  static const String lightMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5" // Light background for map geometry
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161" // Darker text for better contrast
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5" // Light stroke for text
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#0288a6" // Use your primary color for locality labels
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#05AB9F" // Use your secondary color for POI labels
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e0f2f1" // Light green for parks
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76" // Darker green for park labels
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff" // White roads
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e0e0e0" // Light gray for road borders
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161" // Darker text for road labels
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e0e0e0" // Light gray for highways
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#bdbdbd" // Slightly darker gray for highway borders
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#0288a6" // Use your primary color for highway labels
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e0e0e0" // Light gray for transit geometry
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#05AB9F" // Use your secondary color for transit labels
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#B2E0E7" // Light blue-green for water
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#0288a6" // Use your primary color for water labels
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5" // Light stroke for water labels
      }
    ]
  }
]
''';
}
