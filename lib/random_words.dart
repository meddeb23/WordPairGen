import 'package:flutter/material.dart';
import "package:english_words/english_words.dart";

class RandomWord extends StatefulWidget {
  RandomWord({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RandomWordState createState() => _RandomWordState();
}

class _RandomWordState extends State<RandomWord> {
  final _randomWordPair = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();

          final index = item ~/ 2;

          if (index <= _randomWordPair.length) {
            _randomWordPair.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPair[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alradySaved = _savedWordPairs.contains(pair);

    return ListTile(
      title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
      trailing: Icon(
        alradySaved ? Icons.favorite : Icons.favorite_border,
        color: alradySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alradySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16.0)),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ListView(
            children: _savedWordPairs.length != 0
                ? divided
                : [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: Text("Empty", style: TextStyle(fontSize: 18.0)),
                    ))
                  ],
          ));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: _pushSaved,
            )
          ],
        ),
        body: _buildList());
  }
}
