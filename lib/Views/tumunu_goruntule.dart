import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tarif_kitabi/Utils/renk.dart';
import 'package:tarif_kitabi/Widget/yemek_ekrani.dart';
import 'package:tarif_kitabi/Widget/icon_buton.dart';

class TumunuGoruntule extends StatefulWidget {
  const TumunuGoruntule({super.key});

  @override
  State<TumunuGoruntule> createState() => _TumunuGoruntuleState();
}

class _TumunuGoruntuleState extends State<TumunuGoruntule> {
  final CollectionReference completeApp =
      FirebaseFirestore.instance.collection("Complete-Flutter-App");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        automaticallyImplyLeading: false, // it remove the appbar back button
        elevation: 0,
        actions: [
          SizedBox(
            width: 15,
          ),
          IconButon(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            "Hızlı & Kolay",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButon(
            icon: Iconsax.notification,
            pressed: () {},
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Column(
                        children: [
                          YemekEkrani(documentSnapshot: documentSnapshot),
                          Row(
                            children: [
                              Icon(
                                Iconsax.star1,
                                color: Colors.amberAccent,
                              ),
                              SizedBox(width: 5),
                              Text(
                                documentSnapshot['rate'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("/5"),
                              const SizedBox(width: 5),
                              Text(
                                "${documentSnapshot['reviews'.toString()]} Görüntülenme",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                }
                // it means if snapshot has data then show the date otherwise show the progress bar
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
