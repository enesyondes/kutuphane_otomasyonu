import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/homepage.dart';
import './services/firestore.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cep Kütüphanem',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 65, 2, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cep Kütüphanem'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirestoreService firestore = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(100, 255, 0, 0),
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Anasayfa())),
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: const Color.fromARGB(212, 162, 0, 0),
          alignment: const FractionalOffset(0.5, 0.75),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          constraints: const BoxConstraints(maxHeight: 1000),
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.getBook(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List bookList = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: bookList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = bookList[index];
                      String bookId = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String kitapAd = data['ad'];
                      String kitapSayfa = data['sayfa'];
                      String kitapYazar = data['yazar'];
                      bool yayin = data['liste'];
                      if (yayin == true) {
                        return Container(
                            margin: const EdgeInsets.all(3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ListTile(
                                title: Text(kitapAd,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                                subtitle: Text(
                                    "Yazar:$kitapYazar, Sayfa Sayısı:$kitapSayfa",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    )),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Anasayfa()));
                                          firestore.delete(bookId);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: const Text(
                                                        'Silmek İstediğinize Emin Misiniz?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Vazgeç'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          firestore
                                                              .delete(bookId);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Evet eminim'),
                                                      )
                                                    ]);
                                              });
                                        },
                                      )
                                    ])));
                      }
                      return null;
                    });
              } else {
                return const Text("Kitap Ekleyin");
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Kitaplar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Kitap Ekle',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app), label: 'Çıkış Yap'),
          ],
          onTap: (int index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Anasayfa()),
              );
            } else if (index == 2) {
              SystemNavigator.pop(); // Uygulamayı kapat
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                          title: 'Ana Sayfa',
                        )),
              );
            }
          },
        ));
  }
}
