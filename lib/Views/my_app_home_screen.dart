import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tarif_kitabi/Utils/renk.dart';
import 'package:tarif_kitabi/Views/tumunu_goruntule.dart';
import 'package:tarif_kitabi/Widget/afis.dart';
import 'package:tarif_kitabi/Widget/yemek_ekrani.dart';
import 'package:tarif_kitabi/Widget/icon_buton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUygulamaAnaEkrani extends StatefulWidget {
  const MyUygulamaAnaEkrani({super.key});

  @override
  State<MyUygulamaAnaEkrani> createState() => _MyUygulamaAnaEkraniState();
}

class _MyUygulamaAnaEkraniState extends State<MyUygulamaAnaEkrani> {
  final ScrollController _scrollController = ScrollController();
  String kategori = "Hepsi";
  
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("App-Category");
  
  Query get filteredtarifler =>
      FirebaseFirestore.instance.collection("Complete-Flutter-App").where(
            'category',
            isEqualTo: kategori,
          );
  Query get tumTarifler =>
      FirebaseFirestore.instance.collection("Complete-Flutter-App");
  Query get secilenTarifler =>
      kategori == "Hepsi" ? tumTarifler : filteredtarifler;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(context),
                    //mySearchBar(),
                    // for banner (afiş için)
                    const Afis(),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        "Kategoriler",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    secilenKategori(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hızlı & Kolay",
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TumunuGoruntule(),
                              ),
                            );
                          },
                          child: Text(
                            "Tümünü görüntüle",
                            style: TextStyle(
                              color: kBannerColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: secilenTarifler.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> tarifler =
                        snapshot.data?.docs ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: ScrollConfiguration(
                        behavior:
                            MyCustomScrollBehavior(), // Özel scroll davranışı burada ekleniyor
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Row(
                            children: tarifler
                                .map((e) =>
                                    YemekEkrani(documentSnapshot: e))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> secilenKategori() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      // if the data is available the it work
                      kategori = streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          kategori == streamSnapshot.data!.docs[index]["name"]
                              ? kprimaryColor
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: TextStyle(
                        color:
                            kategori == streamSnapshot.data!.docs[index]["name"]
                                ? Colors.white
                                : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        // it means if snapshot has data then show the date otherwise show the progress bar
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  

  Container headerParts(BuildContext context) {
    // Ekran genişliği ve yüksekliği
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Yazı boyutunu ekran genişliğine göre dinamik hesaplama
    final titleFontSize = screenWidth * 0.08; // Genişliğin %8'i
    final subtitleFontSize = screenWidth * 0.06; // Genişliğin %6'sı
    final iconSize = screenWidth * 0.15; // Genişliğin %15'i

    return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.01, // Genişliğin %5'i
        vertical: screenHeight * 0.02, // Yüksekliğin %2'si
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Yumuşak şeffaf arka plan
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4), // Gölgenin yeri
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Sol Taraf: İkon
          Icon(
            Icons.restaurant_menu_rounded,
            size: iconSize,
            color: Colors.deepOrange,
          ),
          SizedBox(width: screenWidth * 0.03), // İkon ve metin arasında boşluk

          // Sağ Taraf: Başlıklar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ömer Usta'nın",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    letterSpacing: 1.1,
                    fontFamily: 'Poppins', // Modern yazı tipi
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Mutfağı",
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                    letterSpacing: 1.5,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
