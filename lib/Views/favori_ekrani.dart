import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tarif_kitabi/Provider/favori_provider.dart';
import 'package:tarif_kitabi/Utils/renk.dart';
import 'package:tarif_kitabi/Views/tarif_detay_ekrani.dart';

class FavoriEkrani extends StatefulWidget {
  const FavoriEkrani({super.key});

  @override
  State<FavoriEkrani> createState() => _FavoriEkraniDurumu();
}

class _FavoriEkraniDurumu extends State<FavoriEkrani> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriProvider.of(context);
    final favoriler = provider.favoriler;
    return Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          backgroundColor: kbackgroundColor,
          centerTitle: true,
          title: Text(
            "Favoriler",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        body: favoriler.isEmpty
            ? const Center(
                child: Text(
                  "Henüz favori yok",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : // Favori öğesi üzerine tıklandığında tarif detayları kısmına yönlendirme
            ListView.builder(
                itemCount: favoriler.length,
                itemBuilder: (context, index) {
                  String favori = favoriler[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Complete-Flutter-App")
                        .doc(favori)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text("Favoriler yüklenirken hata oluştu"),
                        );
                      }
                      var favoriOge = snapshot.data!;

                      return GestureDetector(
                        onTap: () {
                          // Favorilere eklenmiş olan tarifin üzerine tıklandığında, detay ekranına yönlendirme 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TarifDetayEkrani(
                                documentSnapshot: favoriOge,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            favoriOge['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favoriOge['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Iconsax.flash_1,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "${favoriOge['cal']} Kal",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              " . ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.grey),
                                            ),
                                            Icon(
                                              Iconsax.clock,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${favoriOge['time']} Dk",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Favori öğesinin üzerine tıklanabilir olduğunda, silme butonu mevcut
                            Positioned(
                              top: 50,
                              right: 35,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    provider.toggleFavorite(favoriOge);
                                  });
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ));
  }
}
