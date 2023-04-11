class Server {
  final List<String> availableUserDomains;
  final bool inviteCodeRequired;
  final Map links;

  Server({
    required this.availableUserDomains,
    required this.inviteCodeRequired,
    required this.links,
  });
}
