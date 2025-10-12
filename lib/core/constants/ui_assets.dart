/// UI Assets Constants
/// 
/// This file provides easy access to all the UI design assets imported from the
/// /home/mahmoud/Documents/GitHub/ui directory.

class UIAssets {
  UIAssets._(); // Private constructor

  // Main Screen Images
  static const String home = 'assets/ui/Home.png';
  static const String home1 = 'assets/ui/Home-1.png';
  static const String profile = 'assets/ui/Profile.png';
  static const String buds = 'assets/ui/Buds.png';
  static const String cards = 'assets/ui/Cards.png';
  static const String chat = 'assets/ui/Chat.png';
  static const String events = 'assets/ui/Events.png';
  static const String stories = 'assets/ui/Stories.png';
  static const String watchTogether = 'assets/ui/Watch togather.png';

  // Search UI
  static const String discover = 'assets/ui/Search/Discover.png';
  static const String discover1 = 'assets/ui/Search/Discover-1.png';

  // Extra Screens
  static const String loginScreen = 'assets/ui/extra/LogIn.png';
  static const String loginWrongPass = 'assets/ui/extra/LogIn-WrongPass.png';
  static const String signUp = 'assets/ui/extra/Sign up.png';
  static const String signUp1 = 'assets/ui/extra/Sign up-1.png';
  static const String onBoarding = 'assets/ui/extra/on boarding.png';
  
  // Profile and User Info
  static const String userProfile = 'assets/ui/extra/User Profile.png';
  static const String userProfile1 = 'assets/ui/extra/User Profile-1.png';
  static const String changePass = 'assets/ui/extra/Change Pass.png';
  static const String changePass1 = 'assets/ui/extra/Change Pass-1.png';
  
  // Collect Information Screens
  static const String collectInfo = 'assets/ui/extra/Collect information.png';
  static const String collectInfo1 = 'assets/ui/extra/Collect information-1.png';
  static const String collectInfo2 = 'assets/ui/extra/Collect information-2.png';
  static const String collectInfo3 = 'assets/ui/extra/Collect information-3.png';
  
  // Chat Screens
  static const String chats = 'assets/ui/extra/Chats.png';
  static const String chats1 = 'assets/ui/extra/Chats-1.png';
  
  // Email Screens
  static const String resendEmail = 'assets/ui/extra/Resend Email.png';
  static const String resendEmail2 = 'assets/ui/extra/Resend Email2.png';
  
  // Feature Screens
  static const String homeExtra = 'assets/ui/extra/Home.png';
  static const String searchExtra = 'assets/ui/extra/Search.png';
  static const String discoverExtra = 'assets/ui/extra/Discover.png';
  static const String eventExtra = 'assets/ui/extra/Event.png';
  static const String matching = 'assets/ui/extra/Matching.png';
  static const String matchHistory = 'assets/ui/extra/Match History.png';
  static const String watchParty = 'assets/ui/extra/Watch Party.png';

  // Case Study Images
  static const String competitiveAnalysis = 'assets/ui/case_study/Competitve Analysis.png';
  static const String asset4_2 = 'assets/ui/case_study/Asset 4 2.png';
  static const String musicBudCase = 'assets/ui/case_study/MusicBud.png';
  static const String iPhone12Pro = 'assets/ui/case_study/iPhone 12 Pro.png';
  static const String iPhone12Pro1 = 'assets/ui/case_study/iPhone 12 Pro-1.png';
  static const String vector = 'assets/ui/case_study/Vector.png';
  static const String group = 'assets/ui/case_study/Group.png';
  
  // Frame Assets
  static const String frame76023 = 'assets/ui/case_study/Frame 76023.png';
  static const String frame76024 = 'assets/ui/case_study/Frame 76024.png';
  static const String frame76025 = 'assets/ui/case_study/Frame 76025.png';
  
  // Rectangle Assets
  static const String rectangle34624423 = 'assets/ui/case_study/Rectangle 34624423.png';
  static const String rectangle34624426 = 'assets/ui/case_study/Rectangle 34624426.png';
  
  // Group Assets (numbered series)
  static const String group1171275261 = 'assets/ui/case_study/Group 1171275261.png';
  static const String group1171275262 = 'assets/ui/case_study/Group 1171275262.png';
  static const String group1171275263 = 'assets/ui/case_study/Group 1171275263.png';
  static const String group1171275264 = 'assets/ui/case_study/Group 1171275264.png';
  static const String group1171275265 = 'assets/ui/case_study/Group 1171275265.png';
  static const String group1171275266 = 'assets/ui/case_study/Group 1171275266.png';
  static const String group1171275267 = 'assets/ui/case_study/Group 1171275267.png';
  static const String group1171275268 = 'assets/ui/case_study/Group 1171275268.png';
  static const String group1171275269 = 'assets/ui/case_study/Group 1171275269.png';
  static const String group1171275270 = 'assets/ui/case_study/Group 1171275270.png';
  static const String group1171275271 = 'assets/ui/case_study/Group 1171275271.png';
  static const String group1171275272 = 'assets/ui/case_study/Group 1171275272.png';
  static const String group1171275273 = 'assets/ui/case_study/Group 1171275273.png';

  // Helper methods for easier asset access
  static String getMainScreenAsset(String screenName) {
    switch (screenName.toLowerCase()) {
      case 'home':
        return home;
      case 'profile':
        return profile;
      case 'buds':
        return buds;
      case 'chat':
        return chat;
      case 'events':
        return events;
      case 'stories':
        return stories;
      default:
        return home;
    }
  }

  static String getExtraScreenAsset(String screenName) {
    switch (screenName.toLowerCase()) {
      case 'login':
        return loginScreen;
      case 'signup':
        return signUp;
      case 'onboarding':
        return onBoarding;
      case 'profile':
        return userProfile;
      case 'search':
        return searchExtra;
      case 'discover':
        return discoverExtra;
      case 'matching':
        return matching;
      default:
        return homeExtra;
    }
  }

  // List of all main screen assets for galleries or carousels
  static List<String> get mainScreenAssets => [
    home,
    profile,
    buds,
    chat,
    events,
    stories,
    cards,
    watchTogether,
  ];

  // List of all extra screen assets
  static List<String> get extraScreenAssets => [
    loginScreen,
    signUp,
    onBoarding,
    userProfile,
    searchExtra,
    discoverExtra,
    matching,
    matchHistory,
    watchParty,
    chats,
  ];

  // List of case study assets for documentation
  static List<String> get caseStudyAssets => [
    competitiveAnalysis,
    musicBudCase,
    iPhone12Pro,
    frame76023,
    frame76024,
    frame76025,
  ];
}