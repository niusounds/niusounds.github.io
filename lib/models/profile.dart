class Profile {
  final String name;
  final String image;
  final List<Skill> skills;
  final List<Link> links;

  const Profile({
    required this.name,
    required this.image,
    required this.skills,
    required this.links,
  });
}

class Skill {
  final String name;

  const Skill({
    required this.name,
  });
}

class Link {
  final String icon;
  final String title;
  final String url;

  const Link({
    required this.icon,
    required this.title,
    required this.url,
  });
}
