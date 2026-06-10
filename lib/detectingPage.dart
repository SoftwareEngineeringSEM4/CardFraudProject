import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'buttonClick.dart';

class DetectingScreenBody extends StatefulWidget {
  const DetectingScreenBody({super.key});

  @override
  State<DetectingScreenBody> createState() => _DetectingScreenBodyState();
}

class _DetectingScreenBodyState extends State<DetectingScreenBody> {
  final TextEditingController _amtController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int _genderFemale = 0; // 0 = Male, 1 = Female
  String _selectedMerchant = 'Tokopedia';
  
  final List<String> _merchants = [
    'Tokopedia',
    'Shopee',
    'Traveloka',
    'Netflix',
    'Steam',
    'fraud_Hamill-D\'Amore'
  ];

  @override
  void dispose() {
    _amtController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showResultDialog(BuildContext context, bool isFraud) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161E29),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF5A8DEE), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                if (!isFraud)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF24B624), width: 4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF24B624),
                      size: 48,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE53E3E), width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFE53E3E),
                      size: 48,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  isFraud ? 'FRAUD DETECTED' : 'NO FRAUD DETECTED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                CardGuardButton(
                  text: 'CONTINUE',
                  type: ButtonType.secondary,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _runMachineLearningDetection(BuildContext context) async {
    if (_amtController.text.isEmpty || _ageController.text.isEmpty) {
      _showErrorSnackbar('Please fill in both Amount and Age fields.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF5A8DEE))),
    );

    final baseUrl = dotenv.env['MODEL_API'] ?? 'http://127.0.0.1:8000';
    final url = Uri.parse('$baseUrl/detect');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'merchant': _selectedMerchant,
          'amount': double.tryParse(_amtController.text) ?? 0.0,
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _genderFemale == 1 ? 'Female' : 'Male',
        }),
      );

      Navigator.of(context).pop(); // Dismiss loading

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        final dataObj = responseData['data'] ?? responseData;
        
        final predictionStr = dataObj['prediction']?.toString().toLowerCase() ?? '';
        bool isFraud = predictionStr.contains('high') || dataObj['is_fraud'] == true;

        _showResultDialog(context, isFraud);
      } else {
        _showErrorSnackbar('Server Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss loading
      _showErrorSnackbar('Terjadi kesalahan saat memanggil API.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1014),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Icon and Title
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A8DEE).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF5A8DEE),
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FRAUD SCANNER',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter transaction details below to evaluate risk.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // Input Fields
            const Text(
              'Merchant',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF161E29),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMerchant,
                  dropdownColor: const Color(0xFF161E29),
                  icon: const Icon(Icons.storefront, color: Color(0xFF5A8DEE)),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMerchant = newValue;
                      });
                    }
                  },
                  items: _merchants.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildPremiumInputField(
              label: 'Transaction Amount',
              hint: 'e.g., 250.00',
              controller: _amtController,
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 24),

            _buildPremiumInputField(
              label: 'Age',
              hint: 'e.g., 25',
              controller: _ageController,
              icon: Icons.cake_outlined,
            ),
            const SizedBox(height: 24),

            // Gender Selector
            const Text(
              'Gender',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildGenderSelector(),

            const SizedBox(height: 56),

            // Analyze Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () => _runMachineLearningDetection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF3C82F6).withOpacity(0.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.radar, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'START ANALYSIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _genderFemale = 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _genderFemale == 0 ? const Color(0xFF5A8DEE).withOpacity(0.15) : const Color(0xFF161E29),
                border: Border.all(
                  color: _genderFemale == 0 ? const Color(0xFF5A8DEE) : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.male,
                    color: _genderFemale == 0 ? const Color(0xFF5A8DEE) : Colors.white54,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Male',
                    style: TextStyle(
                      color: _genderFemale == 0 ? const Color(0xFF5A8DEE) : Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _genderFemale = 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _genderFemale == 1 ? const Color(0xFFF43F5E).withOpacity(0.15) : const Color(0xFF161E29),
                border: Border.all(
                  color: _genderFemale == 1 ? const Color(0xFFF43F5E) : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.female,
                    color: _genderFemale == 1 ? const Color(0xFFF43F5E) : Colors.white54,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Female',
                    style: TextStyle(
                      color: _genderFemale == 1 ? const Color(0xFFF43F5E) : Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF5A8DEE)),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.normal),
            filled: true,
            fillColor: const Color(0xFF161E29),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF5A8DEE), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}