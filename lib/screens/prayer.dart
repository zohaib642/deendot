import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart' as adhan;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({Key? key}) : super(key: key);

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> with SingleTickerProviderStateMixin {
  // Tab controller for managing the two screens
  late TabController _tabController;
  
  bool isLoading = true;
  String error = "";
  Position? currentPosition;
  adhan.PrayerTimes? prayerTimes;
  
  // Added for region selection
  String selectedRegion = 'North America';
  final List<String> regions = [
    'North America',
    'Muslim World League',
    'Egyptian',
    'Umm Al-Qura',
    'Dubai',
    'Qatar',
    'Kuwait',
    'Singapore',
    'Turkey',
  ];
  
  // Added for madhab selection
  adhan.Madhab selectedMadhab = adhan.Madhab.hanafi;
  bool isHanafiSelected = true;
  
  // Define the main color to be used throughout the app
  final Color mainColor = Color.fromARGB(255, 0, 35, 0);
  final Color cardColor = Color.fromARGB(255, 255, 255, 255);
  
  @override
  void initState() {
    super.initState();
    // Initialize tab controller with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
    _getLocationAndPrayerTimes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission is permanently denied.");
      return false;
    }

    return true;
  }

  Future<void> _getCurrentPosition() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;

      setState(() {
        isLoading = true;
      });

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      setState(() {
        error = "Error getting location: $e";
        isLoading = false;
      });
    }
  }

  // Updated to use selected region and madhab
  void _calculatePrayerTimes() {
    if (currentPosition == null) return;

    try {
      final coordinates = adhan.Coordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      final today = DateTime.now();
      final date = adhan.DateComponents(today.year, today.month, today.day);

      // Use the selected calculation method based on region
      final params = _getCalculationMethodFromRegion().getParameters();
      params.madhab = selectedMadhab;

      final prayerTimesResult = adhan.PrayerTimes(coordinates, date, params);
      setState(() {
        prayerTimes = prayerTimesResult;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error calculating prayer times: $e";
        isLoading = false;
      });
    }
  }

  // Helper method to convert region name to calculation method
  adhan.CalculationMethod _getCalculationMethodFromRegion() {
    switch (selectedRegion) {
      case 'Muslim World League':
        return adhan.CalculationMethod.muslim_world_league;
      case 'Egyptian':
        return adhan.CalculationMethod.egyptian;
      case 'Umm Al-Qura':
        return adhan.CalculationMethod.umm_al_qura;
      case 'Dubai':
        return adhan.CalculationMethod.dubai;
      case 'Qatar':
        return adhan.CalculationMethod.qatar;
      case 'Kuwait':
        return adhan.CalculationMethod.kuwait;
      case 'Singapore':
        return adhan.CalculationMethod.singapore;
      case 'Turkey':
        return adhan.CalculationMethod.turkey;
      case 'North America':
      default:
        return adhan.CalculationMethod.north_america;
    }
  }

  Future<void> _getLocationAndPrayerTimes() async {
    await _getCurrentPosition();
    if (currentPosition != null) {
      _calculatePrayerTimes();
    }
  }

  String _formatPrayerTime(DateTime? time) {
    if (time == null) return 'N/A';
    return DateFormat.jm().format(time);
  }

  // Handle madhab selection
  void _selectMadhab(adhan.Madhab madhab) {
    setState(() {
      selectedMadhab = madhab;
      isHanafiSelected = madhab == adhan.Madhab.hanafi;
      if (currentPosition != null) {
        _calculatePrayerTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData( color: Colors.white),
        title: const Text(
          'Prayer', 
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 35, 0),
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: mainColor, // Removed gradient, using solid color
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w200, fontSize: 16),
              tabs: [
                Tab(
                  icon: Icon(Icons.access_time),
                  text: "Prayer Times",
                ),
                Tab(
                  icon: Icon(Icons.leaderboard),
                  text: "Tracking",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First tab - Prayer Times
          Container(
            color: mainColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPrayerTimesContent(),
              ),
            ),
          ),
          
          // Second tab - Leaderboard/Tracking (Coming Soon)
          _buildTrackingContent(),
        ],
      ),
    );
  }

  Widget _buildPrayerTimesContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(
        color: Color.fromARGB(255, 255, 255, 255),
      ));
    }

    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getLocationAndPrayerTimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                foregroundColor: mainColor,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildPrayerTimesTable();
  }

  Widget _buildTrackingContent() {
    return Container(
      color: mainColor, // Solid color instead of gradient
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              "Coming Soon!",
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Our Prayer Tracking & Leaderboard system is under development. Track your prayers, earn rewards, and compete with friends!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Oxygen',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesTable() {
    return ListView(
      children: [
        // Region Selection dropdown
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedRegion,
                icon: const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 255, 255, 255)),
                elevation: 16,
                dropdownColor: Color.fromARGB(255, 0, 35, 0),
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oxygen',
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedRegion = newValue;
                      if (currentPosition != null) {
                        _calculatePrayerTimes();
                      }
                    });
                  }
                },
                items: regions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        
        // Madhab Selection Buttons
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Text(
                'Madhab: ',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Oxygen',
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(width: 12),
              _buildMadhabButton('Hanafi', isHanafiSelected, () => _selectMadhab(adhan.Madhab.hanafi)),
              SizedBox(width: 16),
              _buildMadhabButton('Shafi', !isHanafiSelected, () => _selectMadhab(adhan.Madhab.shafi)),
            ],
          ),
        ),

        // Next Prayer Info (moved up, before prayer times card)
        if (prayerTimes != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _buildNextPrayerInfo(),
          ),

        // Prayer Times Card (moved down, after next prayer info)
        Card(
          elevation: 4,
          color: cardColor, // Slightly lighter green for the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPrayerTimeRow(
                  'Fajr',
                  _formatPrayerTime(prayerTimes?.fajr),
                ),
                Divider(color: Colors.white30),
                _buildPrayerTimeRow(
                  'Sunrise',
                  _formatPrayerTime(prayerTimes?.sunrise),
                ),
                Divider(color: Colors.white30),
                _buildPrayerTimeRow(
                  'Dhuhr',
                  _formatPrayerTime(prayerTimes?.dhuhr),
                ),
                Divider(color: Colors.white30),
                _buildPrayerTimeRow('Asr', _formatPrayerTime(prayerTimes?.asr)),
                Divider(color: Colors.white30),
                _buildPrayerTimeRow(
                  'Maghrib',
                  _formatPrayerTime(prayerTimes?.maghrib),
                ),
                Divider(color: Colors.white30),
                _buildPrayerTimeRow(
                  'Isha',
                  _formatPrayerTime(prayerTimes?.isha),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: mainColor),
              label: Text(
                'Refresh', 
                style: TextStyle(
                  color: mainColor,
                  fontFamily: 'Oxygen',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _getLocationAndPrayerTimes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for building madhab selection buttons
  Widget _buildMadhabButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
          border: Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oxygen',
            color: isSelected ? mainColor : Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeRow(String prayerName, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w200,
              fontFamily: 'Oxygen',
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w200,
              fontFamily: 'Oxygen',
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerInfo() {
    if (prayerTimes == null) return SizedBox.shrink();

    final now = DateTime.now();
    final prayers = {
      'Fajr': prayerTimes?.fajr,
      'Sunrise': prayerTimes?.sunrise,
      'Dhuhr': prayerTimes?.dhuhr,
      'Asr': prayerTimes?.asr,
      'Maghrib': prayerTimes?.maghrib,
      'Isha': prayerTimes?.isha,
    };

    String? nextPrayer;
    DateTime? nextPrayerTime;
    Duration? timeRemaining;

    for (var entry in prayers.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;

      if (prayerTime != null && prayerTime.isAfter(now)) {
        final currentDifference = prayerTime.difference(now);
        if (timeRemaining == null || currentDifference < timeRemaining) {
          timeRemaining = currentDifference;
          nextPrayer = prayerName;
          nextPrayerTime = prayerTime;
        }
      }
    }

    if (nextPrayer == null) {
      nextPrayer = 'Fajr (Tomorrow)';
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final date = adhan.DateComponents(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
      );

      final coordinates = adhan.Coordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      // Use selected calculation method and madhab for tomorrow's prayer
      final params = _getCalculationMethodFromRegion().getParameters();
      params.madhab = selectedMadhab;

      final tomorrowPrayers = adhan.PrayerTimes(coordinates, date, params);

      nextPrayerTime = tomorrowPrayers.fajr;
      if (nextPrayerTime != null) {
        timeRemaining = nextPrayerTime.difference(now);
      }
    }

    if (timeRemaining == null) return SizedBox.shrink();

    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes.remainder(60);

    return Card(
      color: mainColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Next Prayer',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w200, 
                fontFamily: 'Oxygen',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 8),
            Text(
              nextPrayer,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Oxygen',
                color: Color.fromARGB(255, 200, 255, 200),
              ),
            ),
            SizedBox(height: 4),
            Text(
              nextPrayerTime != null
                  ? _formatPrayerTime(nextPrayerTime)
                  : 'N/A',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Oxygen',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time Remaining: ${hours}h ${minutes}m',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w200, 
                fontFamily: 'Oxygen',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}