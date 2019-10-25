import 'dart:async';
import 'dart:convert';
import 'package:flutter_newsapp/article_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_newsapp/Model/model.dart';

String Api_Key = '7d56963359c04ef5b42c26b735125756';

Future<List<Source>> fetchNewsSource() async {
  final response =
      await http.get('https://newsapi.org/v2/sources?apiKey=${Api_Key}');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((sources) => new Source.fromJson(sources)).toList();
  } else {
    throw Exception('Failed to load source list');
  }
}

void main() => runApp(SourceScreen());

class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coba News',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter News'),
        ),
        body: Center(
          child: RefreshIndicator(
              key: refreshKey,
              child: FutureBuilder<List<Source>>(
                future: list_sources,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Text('Error : ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Source> sources = snapshot.data;
                    return new ListView(
                        children: sources
                            .map((sources) => GestureDetector(
                                  onTap: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen(source: sources,)));
                                  },
                                  child: Card(
                                    elevation: 1.0,
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 14.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          width: 100.0,
                                          height: 140.0,
                                          child: Image.asset("assets/news.png"),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20.0,
                                                              bottom: 10.0),
                                                      child: Text(
                                                          '${sources.name}',
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                child: Text(
                                                    '${sources.description}',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              Container(
                                                child: Text(
                                                    'Category : ${sources.category}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                            .toList());
                  }

                  return CircularProgressIndicator();
                },
              ),
              onRefresh: refreshListSource),
        ),
      ),
    );
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsSource();
    });
    return null;
  }
}
