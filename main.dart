import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Predictive Scoring App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(), // Modern font style
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: PredictiveScoringPage(),
    );
  }
}

class PredictiveScoringPage extends StatefulWidget {
  @override
  _PredictiveScoringPageState createState() => _PredictiveScoringPageState();
}

class _PredictiveScoringPageState extends State<PredictiveScoringPage> {
  final _revenueController = TextEditingController();
  final _incomeController = TextEditingController();
  double? _predictedRating;

  Future<void> _getPredictedRating() async {
    double revenue = double.tryParse(_revenueController.text) ?? 0;
    double income = double.tryParse(_incomeController.text) ?? 0;

    ApiService apiService = ApiService();
    double? rating = await apiService.getCompanyRating(
      revenue: revenue,
      income: income,
    );

    setState(() {
      _predictedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Predictive Scoring App',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar:
          true, // Extend the body behind the AppBar for a seamless look
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade200, Colors.blue.shade900],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Revenue Input Field
              TextField(
                controller: _revenueController,
                decoration: InputDecoration(
                  labelText: 'Revenue (TTM)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),

              // Income Input Field
              TextField(
                controller: _incomeController,
                decoration: InputDecoration(
                  labelText: 'Income (TTM)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Predict Button
              ElevatedButton(
                onPressed: _getPredictedRating,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Get Predicted Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),

              // Predicted Rating Display with Animation
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _predictedRating != null
                    ? Text(
                        'Predicted Rating: ${_predictedRating!.toStringAsFixed(1)}',
                        key: ValueKey(_predictedRating),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Enter values to get a rating',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              SizedBox(height: 20),

              // Disclaimer message box at the bottom
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Disclaimer: Since the model is trained on datasets with revenue and income in Billions, the rating may vary accordingly.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
