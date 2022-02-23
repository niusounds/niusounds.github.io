import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({
    Key? key,
  }) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late Future<String> _privacyText;

  @override
  void initState() {
    super.initState();
    _privacyText = rootBundle.loadString('privacy.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy policy'),
      ),
      body: FutureBuilder<String>(
        future: _privacyText,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(snapshot.data!),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
