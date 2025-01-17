import 'package:admin_atomi_yep/models/choice_model.dart';

class Images {
  static const String n1 = "assets/images/1.jpg";
  static const String n2 = "assets/images/2.png";
  static const String n3 = "assets/images/3.jpg";
  static const String n4 = "assets/images/4.jpg";
  static const String n5 = "assets/images/5.jpg";
  static const String backgroundFirstScreen = "assets/images/background_first_screen.jpg";

  static const String p1 = "assets/images/oh_la_la.png";
  static const String p2 = "assets/images/bug_hunter.png";
  // static const String p3 = "assets/images/chang_trai_lang_man.png";
  static const String p4 = "assets/images/doi_he_thong.png";
  static const String p5 = "assets/images/forbirden_403.png";
  static const String p6 = "assets/images/anh_tai_chi_dep.png";
  static const String p7 = "assets/images/tich_chu_co_lup.png";
  static const String p8 = "assets/images/lien_hop.jpg";
}

List<String> listFake = [
  Images.n1,
  Images.n2,
  Images.n3,
  Images.n4,
  Images.n5,
  Images.n1,
];

class AdminAccount{
  static const String admin = "Hanh HRRRR";
}

List<ChoiceModel> listChoice = [
  ChoiceModel(id: "1", textChoice: "Oh La La", imagePath: Images.p1),
  ChoiceModel(id: "2", textChoice: "BUG HUNTERS", imagePath: Images.p2),
  ChoiceModel(id: "3", textChoice: "Liên Hợp", imagePath: Images.p8),
  ChoiceModel(id: "4", textChoice: "Đội Hệ Thống", imagePath: Images.p4),
  ChoiceModel(id: "5", textChoice: "403 Forbidden", imagePath: Images.p5),
  ChoiceModel(id: "6", textChoice: "Anh tài-Chị đẹp", imagePath: Images.p6),
  ChoiceModel(id: "7", textChoice: "Tích Chu cờ lúp", imagePath: Images.p7),
];
