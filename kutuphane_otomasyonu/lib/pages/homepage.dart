import 'package:kutuphane_otomasyonu/main.dart';
import 'package:kutuphane_otomasyonu/services/firestore.dart';
import 'package:flutter/material.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  Map<String, dynamic> kitap = {};
  bool shouldPublish = false;
  bool intDenetleyici = false;
  final FirestoreService firestore = FirestoreService();
  final TextEditingController adController = TextEditingController();
  final TextEditingController yayinController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController yazarController = TextEditingController();
  final TextEditingController sayfaController = TextEditingController();
  final TextEditingController basimController = TextEditingController();
  final TextEditingController listeController = TextEditingController();
  @override
  void dispose() {
    adController.dispose();
    yayinController.dispose();
    kategoriController.dispose();
    yazarController.dispose();
    sayfaController.dispose();
    basimController.dispose();
    listeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6000,
      color: const Color.fromARGB(255, 243, 235, 235),
      alignment: const FractionalOffset(0.5, 0.75),
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      constraints: const BoxConstraints(maxHeight: 500),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Kitap Ekle veya Düzenle"),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Bu satır ile sayfadan çıkıyoruz
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: adController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Kitap adı',
                ),
                onChanged: (value) {
                  kitap['ad'] = value;
                },
              ),
              TextField(
                controller: yayinController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Yayınevi',
                ),
                onChanged: (value) {
                  kitap['yayin'] = value;
                },
              ),
              DropdownButtonFormField(
                  hint: const Text("Kategori Seç"),
                  items: const [
                    DropdownMenuItem(
                      value: "Roman",
                      child: Text("Roman"),
                    ),
                    DropdownMenuItem(
                      value: "Tarih",
                      child: Text("Tarih"),
                    ),
                    DropdownMenuItem(
                      value: "Edebiyat",
                      child: Text("Edebiyat"),
                    ),
                    DropdownMenuItem(
                      value: "Şiir",
                      child: Text("Şiir"),
                    ),
                    DropdownMenuItem(
                      value: "Ansiklopedi",
                      child: Text("Ansiklopedi"),
                    ),
                  ],
                  onChanged: (value) => {kitap['kategori'] = value}),
              TextField(
                controller: yazarController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Yazarlar',
                ),
                onChanged: (value) {
                  kitap['yazar'] = value;
                },
              ),
              TextField(
                  controller: sayfaController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Sayfa Sayısı',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (int.tryParse(value) == null) {
                        intDenetleyici = true;
                      } else {
                        kitap['sayfa'] = value;
                        intDenetleyici = false;
                      }
                    }
                  }),
              TextField(
                controller: basimController,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Basım Yılı',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      intDenetleyici = true;
                    } else {
                      kitap['yil'] = value;
                      intDenetleyici = false;
                    }
                  }
                },
              ),
              CheckboxListTile(
                  title: const Text('Kitap Yayınlansın mı?'),
                  value: shouldPublish,
                  onChanged: (bool? newValue) {
                    setState(() {
                      shouldPublish = newValue ?? false;
                    });
                    kitap['liste'] = shouldPublish;
                  }),
              ElevatedButton(
                onPressed: () => {
                  if (int.tryParse(kitap['sayfa']) == null ||
                      int.tryParse(kitap['yil']) == null)
                    {}
                  else
                    {
                      if (kitap['ad'] == null) {kitap['ad'] = 'Tanımlanmadı'},
                      if (kitap['yayin'] == null)
                        {kitap['yayin'] = 'Tanımlanmadı'},
                      if (kitap['yazar'] == null)
                        {kitap['yazar'] = "Tanımlanmadı"},
                      if (kitap['kategori'] == null)
                        {kitap['kategori'] = "Tanımlanmadı"},
                      if (kitap['liste'] == null) {kitap['liste'] = false},
                      firestore.addBook(kitap),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()))
                    },
                },
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
