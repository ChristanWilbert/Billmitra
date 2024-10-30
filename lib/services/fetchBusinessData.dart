import 'package:bill_mitra/data/ChartData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<List<ChartData>> fetchData(
    DateTime beginDate, DateTime endDate, String _selectedMetric) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('BusinessMetrics')
      .where(FieldPath.documentId,
          isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(beginDate))
      .where(FieldPath.documentId,
          isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endDate))
      .get();

  // Map Firestore data to _ChartData format
  List<ChartData> data = snapshot.docs.map((doc) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(doc.id);
    double value;

    // Use the metric chosen in your frontend to decide which value to pick
    switch (_selectedMetric) {
      case 'Sales':
        value = (doc['sales'] ?? 0)
            .toDouble(); // Ensure value is converted to double
        break;
      case 'Profit':
        value = (doc['profit'] ?? 0).toDouble();
        break;
      case 'Expense':
        value = (doc['expense'] ?? 0).toDouble();
        break;
      case 'Capital':
        value = (doc['capital'] ?? 0).toDouble();
        break;
      default:
        value = 0.0;
    }

    return ChartData(date, value);
  }).toList();

  return data;
}
