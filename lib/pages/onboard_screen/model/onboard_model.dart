class OnBoardModel {
  final String title;
  final String description;
  final String imageName;

  OnBoardModel(this.title, this.description, this.imageName);

  String get imageWithPath => 'assets/images/$imageName.png';
}

class OnBoardModels {
  static final List<OnBoardModel> onBoardItems = [
    OnBoardModel(
        'Üye Olmanıza Gerek Yok',
        'Now you can order food any time right from your mobile. ',
        'ic_blockchain'),
    OnBoardModel(
        'Kolay Bir Şekilde Kullanın',
        'Now you can order food any time right from your mobile. ',
        'ic_calculator'),
    OnBoardModel(
        'Piyasayı Hızlı Bir Şekilde Takip Edin',
        'Now you can order food any time right from your mobile. ',
        'ic_analytic'),
  ];
}
