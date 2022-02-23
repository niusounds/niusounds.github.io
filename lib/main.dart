import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'impl/firebase/firebase_bbs_repository.dart';
import 'models/profile.dart';
import 'pages/bbs.dart';
import 'pages/home.dart';
import 'pages/privacy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メタルおじさんの部屋',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(
              profile: Profile(
                name: 'Yuya Matsuo',
                image: 'images/web_profile.png',
                skills: [
                  Skill(name: 'Android'),
                  Skill(name: 'Java'),
                  Skill(name: 'Kotlin'),
                  Skill(name: 'HTML'),
                  Skill(name: 'CSS'),
                  Skill(name: 'JavaScript'),
                  Skill(name: 'Node.js'),
                  Skill(name: 'Flutter'),
                  Skill(name: 'Dart'),
                  Skill(name: 'iOS'),
                  Skill(name: 'Swift'),
                  Skill(name: 'Unity'),
                  Skill(name: 'Firebase'),
                  Skill(name: 'Go'),
                ],
                links: [
                  Link(
                    icon: 'github',
                    title: 'GitHub',
                    url: 'https://github.com/niusounds',
                  ),
                  Link(
                    icon: 'twitter',
                    title: 'Twitter',
                    url: 'https://twitter.com/niusounds',
                  ),
                  Link(
                    icon: 'facebook',
                    title: 'Facebook',
                    url: 'https://facebook.com/niusounds',
                  ),
                ],
              ),
            ),
        '/bbs': (_) => BbsPage(
              repository: FirebaseBbsRepository(
                firestore: FirebaseFirestore.instance,
              ),
              dateFormat: DateFormat('yyyy/MM/dd HH:mm'),
            ),
        '/privacy': (_) => const PrivacyPage(),
      },
    );
  }
}
