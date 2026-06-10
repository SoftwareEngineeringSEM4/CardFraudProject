import 'package:flutter/material.dart';

void main() {
  runApp(const CardGuardApp());
}

class CardGuardApp extends StatelessWidget {
  const CardGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E12), // Latar belakang gelap
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF11161D),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Ikon Perisai Kiri
              Icon(Icons.shield_outlined, color: Colors.blue[400], size: 28),
              const SizedBox(width: 8),
              // Teks Judul
              const Text(
                'CardGuard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Ikon Profil Kanan
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                radius: 18,
                child: Icon(Icons.person, color: Colors.blue[900], size: 22),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. Placeholder Kartu Kredit
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9), // Warna abu-abu muda
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Tombol "View All Transactions"
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C86F9), // Warna biru tombol
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View All Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Panel "Risk Insights"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9), // Warna abu-abu muda
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Judul Panel
                    const Text(
                      'Risk Insights',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Garis Pemisah Biru
                    Container(
                      height: 1,
                      width: 250,
                      color: const Color(0xFF4C86F9),
                    ),
                    const SizedBox(height: 16),
                    
                    // Baris Data 1
                    _buildRiskItem(
                      mainText: 'No risk patterns detected',
                      subText: 'Last scan: 6 hours ago',
                    ),
                    const SizedBox(height: 12),
                    
                    // Baris Data 2
                    _buildRiskItem(
                      mainText: 'No risk patterns detected',
                      subText: 'Last scan: 2 minutes ago',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Padding bawah tambahan
            ],
          ),
        ),
      ),
      // 4. Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF11161D),
        selectedItemColor: const Color(0xFF4C86F9),
        unselectedItemColor: const Color(0xFF4C86F9).withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  // Widget pembantu untuk item di dalam Risk Insights
  Widget _buildRiskItem({required String mainText, required String subText}) {
    return Column(
      children: [
        Text(
          mainText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subText,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}