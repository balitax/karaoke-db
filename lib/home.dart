import 'package:flutter/material.dart';
import './lagu.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:firebase_admob/firebase_admob.dart';


const APP_ID = "ca-app-pub-1330672114965626~4804723717";
const ADS_BANNER = "ca-app-pub-1330672114965626/1795416994";
const ADS_INTERSTITIAL = "ca-app-pub-1330672114965626/9215823587";

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: APP_ID != null ? [APP_ID] : null,
    keywords: ['Song', 'Music', "Indonesia", "Youtube"],
  );

  BannerAd bannerAd;
  static InterstitialAd interstitialAd;

  BannerAd buildBanner() {
    return BannerAd(
       adUnitId: ADS_BANNER,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  static InterstitialAd buildInterstitial() {
    return InterstitialAd(
       adUnitId: ADS_INTERSTITIAL,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.failedToLoad) {
            interstitialAd..load();
          } else if (event == MobileAdEvent.closed) {
            interstitialAd = buildInterstitial()..load();
          }
          print(event);
        });
  }

  @override
  initState() {
    super.initState();
   FirebaseAdMob.instance.initialize(appId: APP_ID);
    bannerAd = buildBanner()..load();
    interstitialAd = buildInterstitial()..load();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    super.dispose();
  }

  static void playYoutubeVideo(String url) {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyBhvQhKVWhVpNMOX4WfSLnDXrWanKvJuOw",
      videoUrl: url,
      autoPlay: true, //default falase
      fullScreen: true //default false
    );
  }


  static List<Lagu> songItems = [
    Lagu(judulLagu: "Langit Bumi Saksine", penyanyi: "Suliyana ft. Ilux", urlYoutube: "https://www.youtube.com/watch?v=jZx6whIirI4&list=RDrsatlhuW2F4&index=12"),
    Lagu(judulLagu: "Titip Angin Kange", penyanyi: "Genoskun", urlYoutube: "https://www.youtube.com/watch?v=3SWnhpTI0hc&list=RDrsatlhuW2F4&index=14")
  ];

  @override
  Widget build(BuildContext context) {
    
    bannerAd..show();
    interstitialAd..show();

    return Scaffold(
      appBar: topAppBar,
      body: makeBody,
    );
  }

  

  // Make Top App Bar
  PreferredSize topAppBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(255, 0, 0, 1.0),
      title: Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Center(
          child: new Text(
            "GUDANG KARAOKE",
            style:
                new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      actions: <Widget>[],
    ),
  );

  // Make Body
  static final makeBody = Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: songItems.length,
      itemBuilder: (BuildContext context, int index) {
        return makeSongCardView(songItems[index]);
      },
    ),
  );

  // Make List
  static Card makeSongCardView(Lagu song) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: makeListTile(song),
    ),
  );

  // make ListTile
  static ListTile makeListTile( Lagu song) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(Icons.queue_music),
    ),
    title: Text(
      song.judulLagu,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Row(
      children: <Widget>[
        Text(
          song.penyanyi,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
    trailing: Icon(
      Icons.keyboard_arrow_right,
      color: Colors.white,
      size: 30.0,
    ),
    selected: true,
    onTap: () {
      interstitialAd..show();
      playYoutubeVideo(song.urlYoutube);
    },
  );
}
