import 'package:flutter/material.dart';

void main() {
  runApp(const RidesApp());
}

class RidesApp extends StatelessWidget {
  const RidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lagawan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

/* *****************************************************
   MAIN SCREEN WITH BOTTOM NAVIGATION
   **************************************************** */
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTabScreen(),
    MyTripsScreen(),
    MemoriesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: "My Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library_outlined), label: "Memories"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

/* *****************************************************
   HOME ACTIVITY
   **************************************************** */
class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  // Sample trips
  final List<Map<String, dynamic>> availableTrips = [
    {"title": "Mountain Adventure", "date": "Jan 30, 2026", "riders": 4},
    {"title": "River Exploration", "date": "Feb 05, 2026", "riders": 2},
  ];

  final List<Map<String, dynamic>> yourUpcomingTrips = [
    {"title": "North Loop Road Trip", "date": "Jan 25, 2026", "riders": 3},
  ];

  final List<Map<String, dynamic>> completedTrips = [
    {"title": "City Tour", "date": "Dec 10, 2025", "riders": 4},
  ];

  void joinTrip(int index) {
    setState(() {
      var trip = availableTrips.removeAt(index);
      trip["riders"] += 1;
      yourUpcomingTrips.add(trip);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip joined!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lagawan")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Create Trip tapped")));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Available Trips
          const Text(
            "Available Trips",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(availableTrips.length, (index) {
            var trip = availableTrips[index];
            return AvailableTripCard(
              title: trip["title"],
              date: trip["date"],
              riders: trip["riders"],
              onPreview: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JoinTripPreviewScreen()),
                );
              },
              onJoin: () {
                joinTrip(index);
              },
            );
          }),
          const SizedBox(height: 24),

          // 2. Your Upcoming Trips
          const Text(
            "Your Upcoming Trips",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...yourUpcomingTrips.map((trip) {
            return TripCard(
              title: trip["title"],
              date: trip["date"],
              riders: trip["riders"],
              status: TripStatus.upcoming,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TripPreviewScreen()),
                );
              },
            );
          }).toList(),
          const SizedBox(height: 24),

          // 3. Completed Trips
          const Text(
            "Completed Trips",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...completedTrips.map((trip) {
            return TripCard(
              title: trip["title"],
              date: trip["date"],
              riders: trip["riders"],
              status: TripStatus.completed,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CompletedTripPreviewScreen()),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

/* *****************************************************
   AVAILABLE TRIP ACTIVITY
   **************************************************** */
class AvailableTripCard extends StatelessWidget {
  final String title;
  final String date;
  final int riders;
  final VoidCallback onPreview;
  final VoidCallback onJoin;

  const AvailableTripCard({
    super.key,
    required this.title,
    required this.date,
    this.riders = 0,
    required this.onPreview,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("$date · $riders riders"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(onPressed: onPreview, child: const Text("Preview")),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: onJoin, child: const Text("Join")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* *****************************************************
   TRIP ACTIVITY, TRIP STATUS CLASS IS A DATA MODEL CLASS
   **************************************************** */
enum TripStatus { upcoming, ongoing, completed }

class TripCard extends StatelessWidget {
  final String title;
  final String date;
  final int riders;
  final TripStatus status;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.title,
    required this.date,
    this.riders = 0,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.map_outlined),
        title: Text(title),
        subtitle: Text(riders > 0 ? "$date · $riders riders" : date),
        trailing: _statusBadge(),
        onTap: onTap,
      ),
    );
  }

  Widget _statusBadge() {
    Color color;
    String label;

    switch (status) {
      case TripStatus.upcoming:
        color = Colors.blue;
        label = "Upcoming";
        break;
      case TripStatus.ongoing:
        color = Colors.green;
        label = "Ongoing";
        break;
      case TripStatus.completed:
        color = Colors.grey;
        label = "Completed";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

/* *****************************************************
   USER JOINED TRIP ACTIVITY
   **************************************************** */
class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Trips")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Trips you created or joined will appear here."),
        ),
      ),
    );
  }
}

/* *****************************************************
   PAST ACTIVITIES
   **************************************************** */
class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memories")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Completed trips and shared photos appear here."),
        ),
      ),
    );
  }
}

/* *****************************************************
   USER PROFILE ACTIVITY
   **************************************************** */

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("User profile and settings will appear here."),
        ),
      ),
    );
  }
}

/* *****************************************************
   TRIP PREVIEW ACTIVITY FOR AVAILABLE TRIPS
   **************************************************** */
class JoinTripPreviewScreen extends StatelessWidget {
  const JoinTripPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("North Loop Road Trip", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("January 25, 2026 · 8:00 AM"),
            const SizedBox(height: 16),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("A scenic road trip around the north loop with planned stops."),
            const SizedBox(height: 24),
            const Text("Stops", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Starting Point")),
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Fuel Stop")),
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Lunch Stop")),
                  ListTile(leading: Icon(Icons.flag_outlined), title: Text("Destination")),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.login),
                label: const Text("Join This Trip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* *****************************************************
   TRIP PREVIEW ACTIVITY FOR JOINED TRIPS
   **************************************************** */
class TripPreviewScreen extends StatelessWidget {
  const TripPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("North Loop Road Trip", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("January 25, 2026 · 8:00 AM"),
            const SizedBox(height: 16),
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("A scenic road trip around the north loop with planned stops."),
            const SizedBox(height: 24),
            const Text("Stops", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Starting Point")),
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Fuel Stop")),
                  ListTile(leading: Icon(Icons.place_outlined), title: Text("Lunch Stop")),
                  ListTile(leading: Icon(Icons.flag_outlined), title: Text("Destination")),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.navigation),
                label: const Text("Start Navigation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* *****************************************************
   COMPLETED TRIP PREVIEW ACTIVITY
   **************************************************** */
class CompletedTripPreviewScreen extends StatelessWidget {
  const CompletedTripPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Memories")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("City Tour", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Start: Dec 10, 2025 · 9:00 AM"),
            const Text("Arrival: Dec 10, 2025 · 4:30 PM"),
            const SizedBox(height: 16),
            const Text("Stops Log", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  StopLogTile(title: "Starting Point", time: "09:00 AM", notes: "Everyone gathered, brief intro"),
                  StopLogTile(title: "Coffee Stop", time: "10:15 AM", notes: "Quick coffee break"),
                  StopLogTile(title: "Lunch Stop", time: "12:30 PM", notes: "Shared photos, group selfie"),
                  StopLogTile(title: "Destination", time: "04:30 PM", notes: "Trip concluded successfully"),
                  SizedBox(height: 16),
                  Text("Shared Photos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  TripPhotoRow(imageUrls: [
                    "https://picsum.photos/id/1015/200/150",
                    "https://picsum.photos/id/1016/200/150",
                    "https://picsum.photos/id/1018/200/150",
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===========================
   STOP LOG TILE
   =========================== */
class StopLogTile extends StatelessWidget {
  final String title;
  final String time;
  final String notes;

  const StopLogTile({super.key, required this.title, required this.time, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.place),
        title: Text(title),
        subtitle: Text("$time · $notes"),
      ),
    );
  }
}

/* *****************************************************
   PHOTO GALLERY ACTIVITY
   **************************************************** */
class TripPhotoRow extends StatelessWidget {
  final List<String> imageUrls;

  const TripPhotoRow({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrls[index],
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
