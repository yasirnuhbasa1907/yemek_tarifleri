import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tarif_kitabi/Provider/favori_provider.dart';
import 'package:tarif_kitabi/Provider/miktar.dart';
import 'package:tarif_kitabi/Utils/renk.dart';
import 'package:tarif_kitabi/Widget/icon_buton.dart';
import 'package:tarif_kitabi/Widget/miktar_arttir_azalt.dart';
import 'package:url_launcher/url_launcher.dart';

class TarifDetayEkrani extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const TarifDetayEkrani({super.key, required this.documentSnapshot});

  @override
  State<TarifDetayEkrani> createState() => _TarifDetayEkraniState();
}

class _TarifDetayEkraniState extends State<TarifDetayEkrani> {
  @override
  void initState() {

    List<double> baseAmounts = widget.documentSnapshot['ingredientsAmount']
        .map<double>((amount) => double.parse(amount.toString()))
        .toList();
    Provider.of<MiktarProvider>(context, listen: false)
        .setBaseIngredientAmounts(baseAmounts);
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    final provider = FavoriProvider.of(context);
    final miktarProvider = Provider.of<MiktarProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButon(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      IconButon(
                        icon: Iconsax.notification,
                        pressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.documentSnapshot['cal']} Kalori",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.grey),
                      ),
                      Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['time']} Dakika",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.documentSnapshot['rate'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("/5"),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['reviews'.toString()]} Görüntülenme",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Malzemeler",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      MiktarArttirAzalt(
                        mevcutNo: miktarProvider.mevcutNumara,
                        onAdd: () => miktarProvider.miktariArttir(),
                        onRemove: () => miktarProvider.miktariAzalt(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot['ingredientsName']
                                .map<Widget>((ingredient) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          ingredient,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          
                          const Spacer(),
                          Column(
                            children: miktarProvider.updateIngredientAmounts
                                .map<Widget>((amount) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "${amount} gr/ml",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> videoLinkiAl(String documentId) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection("Complete-Flutter-App")
          .doc(documentId)
          .get();

      // Eğer video alanı varsa, linki döndürelim
      return document['video']; // 'video' alanını döndürür
    } catch (e) {
      print("Video bağlantısı alınırken hata oluştu: $e");
      return null; // Hata durumunda null döner
    }
  }

  Future<void> videoyuAc(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView, // Harici tarayıcıda açar
    )) {
      throw 'Video açılamadı: $videoUrl';
    }
  }

  FloatingActionButton startCookingAndFavoriteButton(FavoriProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              // Document ID'yi al
              String documentId = widget.documentSnapshot.id;

              // Firebase'den video linkini al
              String? videoUrl = await videoLinkiAl(documentId);

              // Video bağlantısı varsa, aç
              if (videoUrl != null) {
                videoyuAc(videoUrl);
              } else {
                // Video bulunamadıysa, hata mesajı gösterebiliriz
                print("Video linki bulunamadı");
              }
            },
            child: Text(
              "Pişirmeye Başla",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            onPressed: () {
              provider.toggleFavorite(widget.documentSnapshot);
            },
            icon: Icon(
              provider.varMi(widget.documentSnapshot)
                  ? Iconsax.heart5
                  : Iconsax.heart,
              color: provider.varMi(widget.documentSnapshot)
                  ? Colors.red
                  : Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
