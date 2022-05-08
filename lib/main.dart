// Tasarım Örneği
// Center, Align, AspectRatio, PhysicalModel, ClipRRect, DecoratedBox

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'album.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "/",
      routes: {
        "/": (context) => MyHomePage(title: "Flutter Demo Home Page"),
        "/settings": (context) => SettingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ogrenciler.add("init");
  }

  var sinif = 5;
  var baslik = "Öğrenciler";
  var ogrenciler = ["Mehmet", "Vedat", "Zeynep"];

  void yeniOgrenciEkle(String yeniOgrenci) {
    setState(() {
      ogrenciler = [...ogrenciler, yeniOgrenci];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePageState Build ...");

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("Settings ...");
              Navigator.of(context).pushNamed("/settings");
            },
          ),
          TextButton(
            child: const Text(
              "Merhaba",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              print("Merhaba");
            },
          )
        ],
      ),
      body: SinifBilgisi(
        sinif: sinif,
        baslik: baslik,
        ogrenciler: ogrenciler,
        yeniOgrenciEkle: yeniOgrenciEkle,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ArkaPlan(),
            Positioned(
              top: 100,
              left: 10,
              right: 10,
              bottom: 0,
              child: LayoutBuilder(builder: (context, constraints) {
                print("Constraints.maxwidth: ${constraints.maxWidth}");
                if (constraints.maxWidth > 450) {
                  return Row(
                    children: const [
                      Sinif(),
                      Expanded(
                          child: Text("Seçili olan öğrencinin detayları : ")),
                    ],
                  );
                } else {
                  return const SingleChildScrollView(
                      // child: Sinif()
                  );
                }
              }),
            ),
            const Positioned(
                bottom: 20, left: 10, right: 10, child: OgrenciEkleme()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Merhaba");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("MERHABA")),
          );
        },
        child: Text("FAB"),
      ),
    );
  }
}

class SinifBilgisi extends InheritedWidget {
  const SinifBilgisi({
    Key? key,
    required Widget child,
    required this.sinif,
    required this.baslik,
    required this.ogrenciler,
    required this.yeniOgrenciEkle,
  }) : super(key: key, child: child);

  final int sinif;
  final String baslik;
  final List<String> ogrenciler;
  final void Function(String yeniOgrenci) yeniOgrenciEkle;

  static SinifBilgisi of(BuildContext context) {
    final SinifBilgisi? result =
    context.dependOnInheritedWidgetOfExactType<SinifBilgisi>();
    assert(result != null, 'No SinifBilgisi found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SinifBilgisi old) {
    return sinif != old.sinif ||
        baslik != old.baslik ||
        ogrenciler != old.ogrenciler ||
        yeniOgrenciEkle != old.yeniOgrenciEkle;
  }
}

class Sinif extends StatelessWidget {
  const Sinif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              color: Colors.red,
            ),
            Text(
              "${sinifBilgisi.sinif}. Sınıf",
              textScaleFactor: 2,
            ),
            const Icon(
              Icons.star,
              color: Colors.red,
            ),
          ],
        ),
        Container(
          color: Colors.yellowAccent,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Text(
            sinifBilgisi.baslik,
            textScaleFactor: 1.5,
          ),
        ),
        OgrenciListesi(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text(
            "Öğrencileri yükle ...",
          ),
          onPressed: () async {
            final ogrenciler = SinifBilgisi.of(context).ogrenciler;
            for (final ogrenci in ogrenciler) {
              print("$ogrenci yükleniyor");
              await Future.delayed(Duration(seconds: 1));
              print("$ogrenci yüklendi");
            }
            print("Tüm Öğrenciler yüklendi");
          },
        ),
        ElevatedButton(
          child: const Text(
            "Yeni sayfaya git ...",
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumPage(),
            ));
            // sor(context);
          },
        ),
      ],
    );
  }

  Future<void> sor(BuildContext context) async {
    try {
      bool? cevap = await cevabiAl(context);

      print("cevap geldi : $cevap");
      if (cevap == true) {
        print("Beğendi !!!");
        throw "HATA OLSUN ...";
      } else {
        cevap = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (context) {
            return const VideoEkrani("Keşke beğenseniz ...");
          }),
        );
      }
      if (cevap == true) {
        print("BEĞENDİNİZ !!!");
      }
    } catch (e) {
      print("HATA !!!");
    } finally {
      print("*** İş bitti ...");
    }
  }

  Future<bool?> cevabiAl(BuildContext context) async {
    bool? cevap = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return const VideoEkrani("Videoyu beğendiniz mi?");
        },
      ),
    );
    return cevap;
  }
}

class VideoEkrani extends StatelessWidget {
  final String mesaj;
  const VideoEkrani(
      this.mesaj, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("pop edecek");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              // const Video(),
              const Placeholder(
                fallbackHeight: 150,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(mesaj),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(true);
                },
                child: const Text(
                  "Evet",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(false);
                },
                child: const Text(
                  "Hayır",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        ElevatedButton(
          child: const Text(
            "Play / Pause",
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        )
      ],
    );
  }
}

class OgrenciListesi extends StatelessWidget {
  const OgrenciListesi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context); //sınıf bilgisi referansı
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final o in sinifBilgisi.ogrenciler)
          ...[
            Text(
                o
            ),
            const SizedBox(
              height: 16,
            )
          ],
      ],
    );
  }
}

class OgrenciEkleme extends StatefulWidget {
  const OgrenciEkleme({
    Key? key,
  }) : super(key: key);

  @override
  State<OgrenciEkleme> createState() => _OgrenciEklemeState();
}

class _OgrenciEklemeState extends State<OgrenciEkleme> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: controller.text.isEmpty
                ? null
                : () {
              final yeniOgrenci = controller.text;
              sinifBilgisi.yeniOgrenciEkle(yeniOgrenci);
              controller.text = "";
            },
            child: const Text(
              "Ekle",
            ),
          ),
        ),
      ],
    );
  }
}

class ArkaPlan extends StatelessWidget {
  const ArkaPlan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: PhysicalModel(
        color: Colors.white,
        shadowColor: Colors.green,
        elevation: 20,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                // color: Colors.grey.shade800,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
                  child: Image.asset("images/homepage_img_8.png"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
      ),
      body: Container(
        child: Text("Settings Page"),
      ),
    );
  }
}
