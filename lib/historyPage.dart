// Isi file: history_screen.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HistoryScreenBody extends StatefulWidget {
  const HistoryScreenBody({super.key});

  @override
  State<HistoryScreenBody> createState() => _HistoryScreenBodyState();
}

class _HistoryScreenBodyState extends State<HistoryScreenBody> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = fetchHistory();
  }

  Future<List<dynamic>> fetchHistory() async {
    final baseUrl = dotenv.env['MODEL_API'] ?? 'http://127.0.0.1:8000';
    final url = Uri.parse('$baseUrl/history');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['data'] != null) {
        return responseData['data'] as List<dynamic>;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF5A8DEE)));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No history transactions found', style: TextStyle(color: Colors.white70)),
          );
        }

        final historyList = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            final transaction = historyList[index];
            return _buildTransactionItem(
              merchantName: transaction['merchant']?.toString() ?? 'Unknown',
              amount: transaction['amount']?.toString() ?? '0',
              transactionHour: transaction['time']?.toString() ?? 'Unknown',
              transactionDate: transaction['date']?.toString() ?? 'Unknown',
              riskStatus: transaction['status']?.toString() ?? 'Unknown',
              location: transaction['location']?.toString() ?? 'Unknown',
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionItem({
    required String merchantName,
    required String amount,
    required String transactionHour,
    required String transactionDate,
    required String riskStatus,
    required String location,
  }) {
    Color riskColor = riskStatus.toLowerCase().contains('high') ? Colors.redAccent : Colors.greenAccent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transactionDate,
            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161E29),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merchant Name: $merchantName', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Amount: $amount', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Transaction hour: $transactionHour', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Transaction date: $transactionDate', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Risk Status: ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(riskStatus, style: TextStyle(color: riskColor, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Location: $location', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}