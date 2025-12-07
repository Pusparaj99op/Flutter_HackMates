class AppConstants {
  // App Info
  static const String appName = 'HackMate';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String hackathonsCollection = 'hackathons';
  static const String teamsCollection = 'teams';
  static const String teamRequestsCollection = 'team_requests';
  static const String skillsCollection = 'skills';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String hackathonImagesPath = 'hackathon_images';

  // API Endpoints (if needed)
  static const String baseUrl = 'https://api.hackmate.com';

  // UI Constants
  static const double borderRadius = 12.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double elevation = 2.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Limits
  static const int maxTeamSize = 5;
  static const int maxSkillsPerUser = 10;
  static const int maxHackathonDescriptionLength = 1000;

  // Default Values
  static const String defaultProfileImage = 'assets/images/default_profile.png';
  static const String defaultHackathonImage = 'assets/images/default_hackathon.png';

  // Social Links
  static const String githubUrl = 'https://github.com/hackmate';
  static const String discordUrl = 'https://discord.gg/hackmate';
  static const String websiteUrl = 'https://hackmate.com';

  // Support
  static const String supportEmail = 'support@hackmate.com';
  static const String privacyPolicyUrl = 'https://hackmate.com/privacy';
  static const String termsOfServiceUrl = 'https://hackmate.com/terms';
}
