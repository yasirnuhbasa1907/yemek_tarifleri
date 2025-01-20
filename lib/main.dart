import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarif_kitabi/Provider/favori_provider.dart';
import 'package:tarif_kitabi/Provider/miktar.dart';
import 'package:tarif_kitabi/Views/uygulama_ana_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCp0eR8MHNFXqFDJ-9GQ-H5IvO4S_YkQfQ",
          authDomain: "yemekkitabi-5e817.firebaseapp.com",
          databaseURL:
              "https://yemekkitabi-5e817-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "yemekkitabi-5e817",
          storageBucket: "yemekkitabi-5e817.firebasestorage.app",
          messagingSenderId: "475891015749",
          appId: "1:475891015749:web:a153e0349e2e658b7d432c"));
          
  runApp(const BenimUygulamam());
}

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(create: (_)=>FavoriProvider()),
        
        ChangeNotifierProvider(create: (_)=>MiktarProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UygulamaAnaEkrani(),
      ),
    );
  }
}
