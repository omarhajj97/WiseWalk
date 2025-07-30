class Alert {
  final String type;      
  final String title;     
  final String location;  
  final double latitude;
  final double longitude;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? description;
  final String? instruction; 

  Alert({
    required this.type,
    required this.title,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.startTime,
    this.endTime,
    this.description,
    this.instruction,
  });
}