import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'widgets/language_selector.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  bool _hasPermission = false;
  DateTime? _lastReadAt;
  CompassEvent? _lastRead;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPermission();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t.mainPageTitle),
        actions: const [LanguageSelector()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                t.welcome,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              t.counterText,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: t.incrementTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCompass() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("The event has error ");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            Text("Device has no sensors");
          }

          return Center(
            child: Card(
              elevation: 4,
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: Transform.rotate(
                angle: (direction! * (math.pi / 180)),
                child: Image.asset("assets/images/compass.jpg"),
              ),
              // child: Image.asset("assets/images/compass.jpg"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildmanualReader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              final CompassEvent temp = await FlutterCompass.events!.first;

              setState(() {
                _lastRead = temp;
                _lastReadAt = DateTime.now();
              });
            },
            child: Text("Refresh"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$_lastRead"),
              SizedBox(height: 10),
              Text("$_lastReadAt"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Location Permission Required"),
          ElevatedButton(
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermission();
              });
            },
            child: Text("Request Permission"),
          ),
        ],
      ),
    );
  }

  void _fetchPermission() {
    Permission.locationWhenInUse.status.then((status) {
      setState(() {
        _hasPermission = status == PermissionStatus.granted;
      });
    });
  }
}
