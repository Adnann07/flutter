import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Australian Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _australianDollarController =
      TextEditingController();
  final TextEditingController _bangladeshiTakaController =
      TextEditingController();

  final FocusNode _audFocusNode = FocusNode();
  final FocusNode _bdtFocusNode = FocusNode();

  // Converts AUD to BDT and updates the BDT field
  void _convertCurrency() {
    if (_audFocusNode.hasFocus) {
      final double? aud = double.tryParse(_australianDollarController.text);
      if (aud != null) {
        final double bdt = aud * 77.24; // Example conversion rate AUD to BDT
        _bangladeshiTakaController.text = bdt.toStringAsFixed(2);
      } else {
        _bangladeshiTakaController.clear();
      }
    }
  }

  // Converts BDT to AUD and updates the AUD field
  void _convertToAUD() {
    if (_bdtFocusNode.hasFocus) {
      final double? bdt = double.tryParse(_bangladeshiTakaController.text);
      if (bdt != null) {
        final double aud = bdt / 77.24; // Example conversion rate BDT to AUD
        _australianDollarController.text = aud.toStringAsFixed(2);
      } else {
        _australianDollarController.clear();
      }
    }
  }

  String _formattedTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeContainer(
                  context,
                  'Sydney (GMT+5)',
                  Colors.purple,
                  Colors.pinkAccent,
                  offset: 5,
                ),
                _buildTimeContainer(
                  context,
                  'Dhaka',
                  Colors.blue,
                  Colors.cyan,
                  offset: 0,
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _australianDollarController,
              focusNode: _audFocusNode,
              hintText: 'Australian dollars',
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _bangladeshiTakaController,
              focusNode: _bdtFocusNode,
              hintText: 'Bangladeshi taka',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeContainer(
    BuildContext context,
    String label,
    Color startColor,
    Color endColor, {
    required int offset,
  }) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: StreamBuilder<DateTime>(
          stream: Stream.periodic(
            const Duration(seconds: 1),
            (_) => DateTime.now().add(Duration(hours: offset)),
          ),
          builder: (context, snapshot) {
            final currentTime = snapshot.data ?? DateTime.now();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  _formattedTime(currentTime),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
  }) {
    return Container(
      width: 300,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        onChanged: (value) =>
            focusNode == _audFocusNode ? _convertCurrency() : _convertToAUD(),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.black87,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _australianDollarController.dispose();
    _bangladeshiTakaController.dispose();
    _audFocusNode.dispose();
    _bdtFocusNode.dispose();
    super.dispose();
  }
}
