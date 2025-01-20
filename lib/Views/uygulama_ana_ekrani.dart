import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tarif_kitabi/Utils/renk.dart';
import 'package:tarif_kitabi/Views/favori_ekrani.dart';
import 'package:tarif_kitabi/Views/my_app_home_screen.dart';

class UygulamaAnaEkrani extends StatefulWidget {
  const UygulamaAnaEkrani({super.key});

  @override
  State<UygulamaAnaEkrani> createState() => _UygulamaAnaEkraniState();
}

class _UygulamaAnaEkraniState extends State<UygulamaAnaEkrani> {
  int secilenIndex = 0;
  late final List<Widget> page;

  @override
  void initState() {
    page = [
      const MyUygulamaAnaEkrani(),
      const FavoriEkrani(),
      navBarPage(Iconsax.calendar5),
      navBarPage(Iconsax.setting_21),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconSize: 28,
        currentIndex: secilenIndex,
        selectedItemColor: kprimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(color: kprimaryColor, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        onTap: (value) {
          setState(() {
            secilenIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              secilenIndex == 0 ? Iconsax.home5 : Iconsax.home_1,
            ),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              secilenIndex == 1 ? Iconsax.heart5 : Iconsax.heart,
            ),
            label: "Favori",
          ),
          /*BottomNavigationBarItem(
            icon: Icon(
              secilenIndex == 2 ? Iconsax.calendar5 : Iconsax.calendar,
            ),
            label: "Meal Plan",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              secilenIndex == 3 ? Iconsax.setting_21 : Iconsax.setting_2,
            ),
            label: "Ayarlar",
          ),*/
        ],
      ),
      body: page[secilenIndex],
    );
  }

  navBarPage(iconName) {
    return Center(
      child: Icon(
        iconName,
        size: 100,
        color: kprimaryColor,
      ),
    );
  }
}
