import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/covid_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'COVID-19'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CoivdResult _dataFromWebAPI;

  @override
  void initState() {
    super.initState();

    print('initState');
    getData();
  }

  Future<void> getData() async {
    print('get data');
    var response = await http.get('https://covid19.th-stat.com/api/open/today');
    print(response.body);

    setState(() {
      _dataFromWebAPI = coivdResultFromJson(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Confirmed(dataFromWebAPI: _dataFromWebAPI),
          Recovered(dataFromWebAPI: _dataFromWebAPI)
        ],
      ),
    );
  }
}

class Confirmed extends StatelessWidget {
  const Confirmed({
    Key key,
    @required CoivdResult dataFromWebAPI,
  })  : _dataFromWebAPI = dataFromWebAPI,
        super(key: key);

  final CoivdResult _dataFromWebAPI;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Card(
        color: Color.fromRGBO(255, 41, 142, 1),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'ติดเชื้อสะสม',
                style: TextStyle(
                    fontSize: 16, color: Colors.white, fontFamily: 'Kanit'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_dataFromWebAPI?.confirmed ?? "..."}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Kanit'),
                ),
              ),
              Text(
                '[  + ${_dataFromWebAPI?.newConfirmed ?? "..."} ]',
                style: TextStyle(color: Colors.white, fontFamily: 'Kanit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Recovered extends StatelessWidget {
  const Recovered({
    Key key,
    @required CoivdResult dataFromWebAPI,
  })  : _dataFromWebAPI = dataFromWebAPI,
        super(key: key);

  final CoivdResult _dataFromWebAPI;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Card(
              color: Color.fromRGBO(4, 96, 52, 1),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'หายแล้ว',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_dataFromWebAPI?.recovered ?? "..."}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                            color: Colors.white),
                      ),
                    ),
                    Text(
                      '[  + ${_dataFromWebAPI?.newRecovered ?? "..."} ]',
                      style:
                          TextStyle(fontFamily: 'Kanit', color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
//รักษาอยู่ใน

          Expanded(
            flex: 1,
            child: Card(
              color: Color.fromRGBO(23, 156, 155, 1),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'รักษาอยู่ใน รพ.',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Kanit',
                          color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_dataFromWebAPI?.hospitalized ?? "..."}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                            color: Colors.white),
                      ),
                    ),
                    Text('  ')
                  ],
                ),
              ),
            ),
          ),
//เสียชีวิต
          Expanded(
              flex: 1,
              child: Card(
                color: Color.fromRGBO(102, 102, 102, 1),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'เสียชีวิต',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${_dataFromWebAPI?.deaths ?? "..."}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                              color: Colors.white),
                        ),
                      ),
                      Text('  ')
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
