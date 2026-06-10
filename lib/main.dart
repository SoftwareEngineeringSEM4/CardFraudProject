import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/loginPage.dart';
import 'package:frontend/profilePage.dart';
import 'loginPage.dart';      
import 'historyPage.dart';
import 'detectingPage.dart';
import 'homepage.dart';
import 'registerPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const CardGuardApp());
}

class CardGuardApp extends StatelessWidget {
  const CardGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1014),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B1014),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// Widget ini adalah pengatur utama untuk navigasi antar tab
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0; // 0 = Home, 1 = History, 2 = Shield (Detecting), 3 = Profile

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditukar-tukar berdasarkan tab yang dipilih
    final List<Widget> pages = [
      HomePageBody(onViewAllPressed: () => _onItemTapped(1)), // Tab Home
      const HistoryScreenBody(),                              // Tab History
      const DetectingScreenBody(),                            // Tab Shield / Detecting
      const ProfileScreenBody(),                              // Tab Profil
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      body: pages[_selectedIndex], // Mengubah isi body berdasarkan klik bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF151C24),
        selectedItemColor: const Color(0xFF3C82F6),
        unselectedItemColor: const Color(0xFF3C82F6).withOpacity(0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: 'Shield'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, color: Colors.blue[400], size: 32),
            const SizedBox(width: 8),
            const Text(
              'CardGuard',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundColor: Color(0xFF2B405B),
              radius: 18,
              child: Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ISI DARI HALAMAN HOME ---
class HomePageBody extends StatelessWidget {
  final VoidCallback onViewAllPressed;

  const HomePageBody({super.key, required this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCreditCardContainer(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: onViewAllPressed, // Tombol ini akan otomatis memindahkan ke tab History (index 1)
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C82F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View All Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
          _buildRiskInsightsPanel(),
        ],
      ),
    );
  }

  Widget _buildCreditCardContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(color: const Color(0xFFE2E2E2), borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sim_card, color: Colors.grey[500], size: 40),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('• • •  • • • 4567', style: TextStyle(color: Colors.black87, fontSize: 20, letterSpacing: 2)),
                Text('Exp 10/26', style: TextStyle(color: Colors.black87, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskInsightsPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(color: const Color(0xFFE2E2E2), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Risk Insights', style: TextStyle(color: Color(0xFF1E293B), fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(height: 1, width: double.infinity, color: const Color(0xFF3C82F6).withOpacity(0.5)),
          const SizedBox(height: 16),
          _buildRiskItem(mainText: 'No risk patterns detected', subText: 'Last scan: 6 hours ago'),
          const SizedBox(height: 16),
          _buildRiskItem(mainText: 'No risk patterns detected', subText: 'Last scan: 2 minutes ago'),
        ],
      ),
    );
  }

  Widget _buildRiskItem({required String mainText, required String subText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.shield, color: Color(0xFF3C82F6), size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainText, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(subText, style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14)),
          ],
        ),
      ],
    );
  }
}