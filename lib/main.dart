import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GamePage(title: 'Color Game'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var horiBoxCount = 3;
  final random = Random.secure();
  var randIndex;
  var correct = 0;
  var incorrect = 0;
  var scoreboard = <Player>[];
  final nameController = TextEditingController();
  var gameCounter = 0;
  final roundController = TextEditingController();

  var round = 20;

  var colors = <Color>[];

  _GamePageState() {
    randomizeColor();
    randIndex = random.nextInt((colors.length - 1));
  }

  void randomizeColor() {
    colors = <Color>[];
    for (int i = 0; i < pow(horiBoxCount, 2); i++) {
      var color = Color.fromRGBO(
          random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
      colors.add(color);
    }
    randIndex = random.nextInt((colors.length - 1));
  }

  void pushBoard() {
    scoreboard.sort((a, b) => (b.score.compareTo(a.score)));
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = scoreboard.map((Player player) {
        return ListTile(
          title: Text(
            player.name,
          ),
          subtitle: Text(
            player.score.toString(),
          ),
        );
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Scoreboard"),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: pushBoard,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Correct: ${correct}  Incorrect ${incorrect}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: GridView.count(
                crossAxisCount: horiBoxCount,
                children: colors.map(colorContainer).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter the Value',
                    errorText: nameController.text.isEmpty
                        ? 'Name Can\'t Be Empty'
                        : null,
                  ),
                  controller: nameController,
                ),
              ),
            ),
            Center(
              child: Container(
                  child: Text(
                      'Red: ${colors[randIndex].red.toString()}, Green: ${colors[randIndex].green.toString()}, Blue: ${colors[randIndex].blue.toString()}')),
            ),
            IconButton(
              onPressed: () {
                reset();
              },
              color: Colors.blue,
              icon: Icon(
                Icons.restore,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    return setState(() {
      scoreboard.add(Player(nameController.text, correct));
      randomizeColor();
      correct = 0;
      incorrect = 0;
      gameCounter = 0;
    });
  }

  Widget colorContainer(Color color) {
    return Container(
      child: FlatButton(
        color: color,
        onPressed: () {
          setState(() {
            if (nameController.text.isEmpty) {
              return;
            }

            if (colors[randIndex] == color) {
              correct++;
            } else {
              incorrect++;
            }

            if (gameCounter >= round) {
              gameCounter = 0;
              reset();
            }

            gameCounter++;
            randomizeColor();
          });
        },
      ),
    );
  }
}

class Player {
  int score;
  String name = "noname";
  Player(this.name, this.score);
}
