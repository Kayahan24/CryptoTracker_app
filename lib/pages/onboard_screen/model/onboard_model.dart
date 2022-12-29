class OnBoardModel {
  final String title;
  final String description;
  final String imageName;

  OnBoardModel(this.title, this.description, this.imageName);

  String get imageWithPath => 'assets/images/$imageName.png';
}

class OnBoardModels {
  static final List<OnBoardModel> onBoardItems = [
    OnBoardModel('Üye Olmanıza Gerek Yok',
        'Uygulamamızı üye olmadan kullanın. ', 'ic_blockchain'),
    OnBoardModel(
        'Kolay Bir Şekilde Hesaplama Yapın',
        'Coinlerin TL ve USD karşılığındaki değerlerini hesaplayın. ',
        'ic_calculator'),
    OnBoardModel('Piyasayı Hızlı Bir Şekilde Takip Edin',
        'Güncel verilerle piyasayı takip edin. ', 'ic_analytic'),
  ];
}
