import 'package:flutter/material.dart';

void main() => runApp(TempConverterApp());

class TempConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TempConverterHome(),
    );
  }
}

class TempConverterHome extends StatefulWidget {
  @override
  _TempConverterHomeState createState() => _TempConverterHomeState();
}

class _TempConverterHomeState extends State<TempConverterHome> {
  final List<Map<String, String>> _history = [];

  void _addConversionToHistory(String input, String result) {
    setState(() {
      _history.insert(0, {'input': input, 'result': result});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Temperature Converter'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Convert'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TempConverterScreen(addConversionToHistory: _addConversionToHistory),
            ConversionHistory(history: _history),
          ],
        ),
      ),
    );
  }
}

class TempConverterScreen extends StatefulWidget {
  final Function(String, String) addConversionToHistory;

  TempConverterScreen({required this.addConversionToHistory});

  @override
  _TempConverterScreenState createState() => _TempConverterScreenState();
}

class _TempConverterScreenState extends State<TempConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _convertedValue = '';
  String _selectedConversion = 'C to F';

  void _convertTemperature() {
    setState(() {
      double? inputValue = double.tryParse(_controller.text);
      if (inputValue != null) {
        if (_selectedConversion == 'C to F') {
          _convertedValue = '${(inputValue * 9 / 5) + 32} °F';
        } else {
          _convertedValue = '${(inputValue - 32) * 5 / 9} °C';
        }
        widget.addConversionToHistory(_controller.text, _convertedValue);
      } else {
        _convertedValue = 'Invalid input';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: _selectedConversion,
            onChanged: (String? newValue) {
              setState(() {
                _selectedConversion = newValue!;
              });
            },
            items: <String>['C to F', 'F to C']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter temperature below:',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _convertTemperature,
            child: Text('Convert'),
          ),
          SizedBox(height: 20),
          Text(
            _convertedValue,
            style: TextStyle(fontSize: 50),
          ),
        ],
      ),
    );
  }
}

class ConversionHistory extends StatelessWidget {
  final List<Map<String, String>> history;

  ConversionHistory({required this.history});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          title: Text(item['input']!),
          subtitle: Text(item['result']!),
        );
      },
    );
  }
}
