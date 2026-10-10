import 'package:flutter/material.dart';
import 'screens/belt_screen.dart';
import 'screens/order_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pick Your Own API',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_index == 0 ? 'The Order' : 'The Belt')),
      // IndexedStack keeps both screens alive so Screen 1 doesn't refetch.
      body: IndexedStack(
        index: _index,
        children: const [OrderScreen(), BeltScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'The Order'),
          NavigationDestination(icon: Icon(Icons.public), label: 'The Belt'),
        ],
      ),
    );
  }
}
