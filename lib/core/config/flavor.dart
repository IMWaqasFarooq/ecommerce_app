enum Flavor {
  development,
  production;

  String get envFileName => switch (this) {
        Flavor.development => 'assets/env/.env.development',
        Flavor.production => 'assets/env/.env.production',
      };

  bool get isProduction => this == Flavor.production;
}
