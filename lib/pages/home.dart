import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../models/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.profile,
    this.accessCount,
  }) : super(key: key);

  final Profile profile;
  final int? accessCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.metalOjisansRoom),
        actions: const [
          PrivacyLink(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Center(
            child: ProfileImage(asset: profile.image),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Greeting(),
          ),
          if (accessCount != null)
            AccessCounter(
              accessCount: accessCount!,
            ),
          const Headline('Skills'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Skills(profile.skills),
          ),
          const Headline('Links'),
          ...profile.links.map((link) => LinkItem(link)),
        ],
      ),
    );
  }
}

class Greeting extends StatelessWidget {
  const Greeting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: AppLocalizations.of(context)!.welcomeMessage1 +
            AppLocalizations.of(context)!.welcomeMessage2,
        style: Theme.of(context).textTheme.subtitle1,
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.welcomeMessage3,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/bbs');
              },
          ),
          TextSpan(text: AppLocalizations.of(context)!.welcomeMessage4),
        ],
      ),
    );
  }
}

class AccessCounter extends StatelessWidget {
  const AccessCounter({
    Key? key,
    required this.accessCount,
  }) : super(key: key);

  final int accessCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Wrap(
        children: [
          const Text('あなたは'),
          ...Counter.from(accessCount),
          const Text('人目のお客様です。'),
        ],
      ),
    );
  }
}

/// アクセスカウンターの一桁を表すWidget。
class Counter extends StatelessWidget {
  const Counter({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 16,
      height: 20,
      color: Colors.black,
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }

  /// カウンターの数字から各桁のCounterを返す。
  static Iterable<Widget> from(int count) sync* {
    String countString = count.toString();
    for (var digit in countString.characters) {
      yield Counter(count: int.parse(digit));
    }
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final String asset;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(const Size(640, 640)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Colors.black12,
          ),
        ],
      ),
      child: Image.asset(asset),
    );
  }
}

class Skills extends StatelessWidget {
  const Skills(
    this.skills, {
    Key? key,
  }) : super(key: key);

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: skills
          .map((skill) => Chip(
                label: Text(skill.name),
              ))
          .toList(),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}

class LinkItem extends StatelessWidget {
  const LinkItem(
    this.link, {
    Key? key,
  }) : super(key: key);

  final Link link;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'images/${link.icon}.png',
        width: 48,
      ),
      title: Text(link.title),
      subtitle: Text(link.url),
      onTap: () {
        urlLauncher.launch(link.url);
      },
    );
  }
}

class PrivacyLink extends StatelessWidget {
  const PrivacyLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.privacy_tip),
      onPressed: () {
        Navigator.pushNamed(context, '/privacy');
      },
    );
  }
}
