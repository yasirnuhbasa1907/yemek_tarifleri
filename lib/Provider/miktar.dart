import 'package:flutter/material.dart';

class MiktarProvider extends ChangeNotifier {
  int _mevcutNumara = 1;
  List<double> _baseIngredientAmounts = [];
  int get mevcutNumara => _mevcutNumara;
  
  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    notifyListeners();
  }

  
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) => (amount * _mevcutNumara).toStringAsFixed(1))
        .toList();
  }
  
  void miktariArttir(){
    _mevcutNumara++;
    notifyListeners();
  }
  
  void miktariAzalt(){
    if (_mevcutNumara>1) {
      _mevcutNumara--;
      notifyListeners();
    }
  }
}
