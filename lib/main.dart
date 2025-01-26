import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const KitapTakipUygulamasi());
}

class KitapTakipUygulamasi extends StatelessWidget {
  const KitapTakipUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitap Takip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AnaEkran(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int hedefKitapSayisi = 0;
  List<Kitap> okunanKitaplar = [];
  String aramaSorgusu = "";

  double get ilerlemeYuzdesi {
    if (hedefKitapSayisi == 0) return 0;
    return (okunanKitaplar.length / hedefKitapSayisi) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final filtrelenmisKitaplar = okunanKitaplar
        .where((kitap) =>
            kitap.ad.toLowerCase().contains(aramaSorgusu.toLowerCase()) ||
            kitap.yazar.toLowerCase().contains(aramaSorgusu.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitap Takip'),
        backgroundColor: const Color(0xFF011C26),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF011C26),
      body: Column(
        children: [
          // Hedef ve İlerleme Kartı
          Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Hedef: $hedefKitapSayisi Kitap',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: ilerlemeYuzdesi / 100,
                    backgroundColor: Colors.grey[700],
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ilerlemeYuzdesi.toStringAsFixed(1)}% Tamamlandı',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  if (ilerlemeYuzdesi == 100) const SizedBox(height: 8),
                  if (ilerlemeYuzdesi == 100)
                    Text(
                      'Tebrikler! Hedefinize ulaştınız!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.greenAccent),
                    ),
                ],
              ),
            ),
          ),
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kitap arayın',
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (deger) {
                setState(() {
                  aramaSorgusu = deger;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          // Kitap Listesi
          Expanded(
            child: filtrelenmisKitaplar.isNotEmpty
                ? ListView.builder(
                    itemCount: filtrelenmisKitaplar.length,
                    itemBuilder: (context, indeks) {
                      final kitap = filtrelenmisKitaplar[indeks];
                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kitap.ad,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                kitap.yazar,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey[300]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Eklenme Tarihi: ${DateFormat('dd/MM/yyyy').format(kitap.okumaTarihi)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[400]),
                              ),
                              if (kitap.notlar.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Not: ${kitap.notlar}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[400]),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${kitap.puan}/5',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blueAccent),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blueAccent),
                                        onPressed: () => _kitapDuzenle(kitap),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            okunanKitaplar.remove(kitap);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Hiç kitap eklenmemiş.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _hedefKitapSayisiDuzenle,
            heroTag: 'hedefDuzenle',
            tooltip: 'Hedefi Düzenle',
            child: const Icon(Icons.edit_note),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _yeniKitapEkle,
            heroTag: 'kitapEkle',
            tooltip: 'Kitap Ekle',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _hedefKitapSayisiDuzenle() {
    showDialog(
      context: context,
      builder: (context) {
        int yeniHedef = hedefKitapSayisi;
        return AlertDialog(
          title: const Text('Hedef Kitap Sayısı'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Örn: 10'),
            onChanged: (deger) {
              yeniHedef = int.tryParse(deger) ?? hedefKitapSayisi;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  hedefKitapSayisi = yeniHedef;
                });
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _yeniKitapEkle() {
    showDialog(
      context: context,
      builder: (context) {
        String kitapAdi = '';
        String yazarAdi = '';
        String notlar = '';
        return AlertDialog(
          title: const Text('Yeni Kitap Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Kitap Adı'),
                  onChanged: (deger) => kitapAdi = deger,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Yazar'),
                  onChanged: (deger) => yazarAdi = deger,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Notlar'),
                  maxLines: 3,
                  onChanged: (deger) => notlar = deger,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (kitapAdi.isNotEmpty && yazarAdi.isNotEmpty) {
                  setState(() {
                    okunanKitaplar.add(Kitap(
                      id: DateTime.now().toString(),
                      ad: kitapAdi,
                      yazar: yazarAdi,
                      notlar: notlar,
                      okumaTarihi: DateTime.now(),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _kitapDuzenle(Kitap kitap) {
    showDialog(
      context: context,
      builder: (context) {
        int puan = kitap.puan;
        String notlar = kitap.notlar;
        TextEditingController notlarKontrol =
            TextEditingController(text: notlar);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(kitap.ad),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (indeks) {
                        return IconButton(
                          icon: Icon(
                            indeks < puan ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              puan = indeks + 1;
                            });
                          },
                        );
                      }),
                    ),
                    TextField(
                      controller: notlarKontrol,
                      decoration: const InputDecoration(labelText: 'Notlar'),
                      maxLines: 3,
                      onChanged: (deger) => notlar = deger,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      kitap.puan = puan;
                      kitap.notlar = notlarKontrol.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Kitap {
  final String id;
  final String ad;
  final String yazar;
  int puan;
  String notlar;
  DateTime okumaTarihi;

  Kitap({
    required this.id,
    required this.ad,
    required this.yazar,
    this.puan = 0,
    this.notlar = '',
    required this.okumaTarihi,
  });
}
