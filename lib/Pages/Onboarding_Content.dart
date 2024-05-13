class OnboardingContent{
  String image;
  String title;
  String disccription;
  OnboardingContent({
    required this.image,
    required this.title,
    required this.disccription});

}

List<OnboardingContent> contents =[
  OnboardingContent(
      image: "assets/images/onboarding/onboard_1.png",
      title: "Select from our\n   Best Menu",
      disccription: "Pick your food from our menu\n       More than 30 items",
  ),
  OnboardingContent(
      image: "assets/images/onboarding/onboard_2.png",
      title: "Easy and Online Payement",
      disccription: "You can pay cash on delivery ,\n         Card Payment and\n            UPI Payment ",
  ),
  OnboardingContent(
      image: "assets/images/onboarding/onboard_3.png",
      title: "Quick delivery at Your Doorstep",
      disccription: "Deliver Your food at your\n          Doorstep.",
  ),
];
