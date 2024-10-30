import 'package:bill_mitra/services/fetchBusinessData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:bill_mitra/data/chartData.dart';

class BusinessPerformanceScreen extends StatefulWidget {
  @override
  _BusinessPerformanceScreenState createState() =>
      _BusinessPerformanceScreenState();
}

class _BusinessPerformanceScreenState extends State<BusinessPerformanceScreen> {
  DateTime? _beginDate;
  DateTime? _endDate;
  String _selectedMetric = 'Sales';
  String _selectedTimeScale = 'Daily';

  List<String> _metrics = ['Sales', 'Profit', 'Capital', 'Expense'];
  List<String> _timeScales = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  // List<ChartData> data = [
  //   ChartData(DateTime(2023, 1, 22), 35),
  //   ChartData(DateTime(2023, 2, 11), 28),
  //   ChartData(DateTime(2023, 2, 12), 34),
  //   ChartData(DateTime(2023, 4, 12), 32),
  //   ChartData(DateTime(2023, 5, 28), 40)
  // ];

  //List<ChartData> filteredData = [];
  List<ChartData> _chartData = [];
  Future<void> _loadChartData() async {
    if (_beginDate != null && _endDate != null) {
      List<ChartData> data =
          await fetchData(_beginDate!, _endDate!, _selectedMetric);

      // Aggregate data if needed
      switch (_selectedTimeScale) {
        case 'Weekly':
          _chartData = _aggregateData(data, Duration(days: 7));
          break;
        case 'Monthly':
          _chartData = _aggregateData(data, Duration(days: 30));
          break;
        case 'Yearly':
          _chartData = _aggregateData(data, Duration(days: 365));
          break;
        default:
          _chartData = data;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState(); // Initialize filtered data
  }

  Future<void> _selectDate(BuildContext context, bool isBeginDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != (isBeginDate ? _beginDate : _endDate)) {
      setState(() {
        if (isBeginDate) {
          _beginDate = picked;
        } else {
          _endDate = picked;
        }
        _loadChartData();
      });
    }
  }

  List<ChartData> _aggregateData(List<ChartData> data, Duration interval) {
    if (data.isEmpty) return [];

    List<ChartData> aggregatedData = [];
    DateTime intervalStart = data.first.year;
    double sum = 0;
    int count = 0;

    for (var entry in data) {
      if (entry.year.isBefore(intervalStart.add(interval))) {
        sum += entry.sales;
        count++;
      } else {
        // Calculate average and add to aggregated data
        aggregatedData.add(ChartData(intervalStart, sum / count));
        // Reset for next interval
        intervalStart = entry.year;
        sum = entry.sales;
        count = 1;
      }
    }

    // Add the last interval
    if (count > 0) {
      aggregatedData.add(ChartData(intervalStart, sum / count));
    }

    return aggregatedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Performance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () => _selectDate(context, true),
                  child: Text(_beginDate != null
                      ? DateFormat('dd/MM/yyyy').format(_beginDate!)
                      : 'Begin'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () => _selectDate(context, false),
                  child: Text(_endDate != null
                      ? DateFormat('dd/MM/yyyy').format(_endDate!)
                      : 'End'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedMetric,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                style: const TextStyle(color: Colors.white),
                dropdownColor: Colors.red[400],
                underline: const SizedBox(),
                items: _metrics.map((String metric) {
                  return DropdownMenuItem<String>(
                    value: metric,
                    child: Text(metric),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMetric = newValue!;
                  });
                  _loadChartData(); // Filter data when metric changes
                },
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  intervalType: _selectedTimeScale == 'Daily'
                      ? DateTimeIntervalType.days
                      : (_selectedTimeScale == 'Weekly'
                          ? DateTimeIntervalType.auto
                          : (_selectedTimeScale == 'Monthly'
                              ? DateTimeIntervalType.months
                              : DateTimeIntervalType.years)),
                ),
                series: <CartesianSeries<ChartData, DateTime>>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData sales, _) => sales.year,
                    yValueMapper: (ChartData sales, _) => sales.sales,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedTimeScale,
                style: const TextStyle(color: Colors.white),
                dropdownColor: Colors.green,
                items: _timeScales.map((String scale) {
                  return DropdownMenuItem<String>(
                    value: scale,
                    child: Text(scale),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeScale = newValue!;
                    _loadChartData(); // Update chart data based on new time scale
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
