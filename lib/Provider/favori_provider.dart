import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favoriler => _favoriteIds;

  FavoriProvider() {
    favorileriYukle();
  }
  
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _favoriKaldir(productId); 
    } else {
      _favoriteIds.add(productId);
      await _favoriEkle(productId); 
    }
    notifyListeners();
  }

  
  bool varMi(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  
  Future<void> _favoriEkle(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).set({
        'isFavorite':
            true, 
      });
    } catch (e) {
      print(e.toString());
    }
  }

  
  Future<void> _favoriKaldir(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  
  Future<void> favorileriYukle() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  
  static FavoriProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriProvider>(
      context,
      listen: listen,
    );
  }
}
