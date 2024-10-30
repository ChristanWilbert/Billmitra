import 'package:bill_mitra/data/ChartData.dart';
import 'package:bill_mitra/services/fetchBusinessData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BusinessPredictionScreen extends StatefulWidget {
  @override
  _BusinessPredictionScreenState createState() =>
      _BusinessPredictionScreenState();
}

class _BusinessPredictionScreenState extends State<BusinessPredictionScreen> {
  DateTime? _beginDate;
  DateTime? _endDate;
  String _selectedMetric = 'Sales';
  String _selectedTimeScale = 'Daily';
  List<String> _metrics = ['Sales', 'Profit', 'Capital', 'Expense'];
  List<String> _timeScales = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  List<ChartData> _chartData = [];
  List<ChartData> _predictedData = [];

  Future<void> _loadChartData() async {
    if (_beginDate != null && _endDate != null) {
      // Fetch and prepare the data based on the metric and timescale
      List<ChartData> data =
          (await fetchData(_beginDate!, _endDate!, _selectedMetric))
              .cast<ChartData>();
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

      // Generate predictions
      _predictedData = _generatePredictions(_chartData);

      setState(() {});
    }
  }

  List<ChartData> _generatePredictions(List<ChartData> data) {
    if (data.length < 2) return []; // Not enough data for prediction

    // Use the date of the first data point as a reference for x-values
    DateTime referenceDate = data.first.date;

    // Accumulators for linear regression
    double xSum = 0, ySum = 0, xySum = 0, x2Sum = 0;
    int n = data.length;

    // Calculate the x (time in days since reference date) and y (value) sums
    for (var i = 0; i < n; i++) {
      int daysFromReference = data[i].date.difference(referenceDate).inDays;
      double yValue = data[i].value;

      xSum += daysFromReference;
      ySum += yValue;
      xySum += daysFromReference * yValue;
      x2Sum += daysFromReference * daysFromReference;
    }

    // Calculate slope and intercept for the line of best fit
    double slope = (n * xySum - xSum * ySum) / (n * x2Sum - xSum * xSum);
    double intercept = (ySum - slope * xSum) / n;

    // Generate predictions starting from the last date in data
    List<ChartData> predictions = [];
    DateTime lastDate = data.last.date;
    int lastXValue = lastDate.difference(referenceDate).inDays;

    // Generate 5 predictions based on selected time scale
    for (int i = 1; i <= 5; i++) {
      DateTime nextDate;
      if (_selectedTimeScale == 'Daily') {
        nextDate = lastDate.add(Duration(days: i));
      } else if (_selectedTimeScale == 'Weekly') {
        nextDate = lastDate.add(Duration(days: 7 * i));
      } else if (_selectedTimeScale == 'Monthly') {
        nextDate = DateTime(lastDate.year, lastDate.month + i, lastDate.day);
      } else {
        // Yearly
        nextDate = DateTime(lastDate.year + i, lastDate.month, lastDate.day);
      }

      // Convert nextDate to x value in days from reference date for prediction
      int nextXValue = nextDate.difference(referenceDate).inDays;
      double predictedValue = slope * nextXValue + intercept;
      predictions.add(ChartData(nextDate, predictedValue));
    }

    return predictions;
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
    DateTime intervalStart = data.first.date;
    double sum = 0;
    int count = 0;

    for (var entry in data) {
      if (entry.date.isBefore(intervalStart.add(interval))) {
        sum += entry.value;
        count++;
      } else {
        // Calculate average and add to aggregated data
        aggregatedData.add(ChartData(intervalStart, sum / count));
        // Reset for next interval
        intervalStart = entry.date;
        sum = entry.value;
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => _selectDate(context, false),
                  child: Text(_endDate != null
                      ? DateFormat('dd/MM/yyyy').format(_endDate!)
                      : 'End'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedMetric,
              items: _metrics.map((String metric) {
                return DropdownMenuItem<String>(
                  value: metric,
                  child: Text(metric),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMetric = newValue!;
                  _loadChartData();
                });
              },
            ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <CartesianSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Actual Data',
                  ),
                  LineSeries<ChartData, DateTime>(
                    dataSource: _predictedData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    name: 'Predicted Data',
                    dashArray: <double>[5, 5],
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
