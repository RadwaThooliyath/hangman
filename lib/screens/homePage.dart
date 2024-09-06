import 'package:flutter/material.dart';
import 'package:hangman/screens/home2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> alphabet = List.generate(21, (index) => String.fromCharCode(index + 65));
  final List<String> lastAlphabet = ['V', 'W', 'X', 'Y', 'Z'];
  final List<String> targetWord = ['B', 'A', 'S', 'I', 'T', 'H'];
  List<String> currentWord = [];
  int errorCount = 0;
  final List<String> hangmanImages = [
    'assets/hang.png',
    'assets/head.png',
    'assets/body.png',
    'assets/lefthand.png',
    'assets/righthand.png',
    'assets/leftleg.png',
    'assets/rightleg.png',
  ];

  void _onLetterPressed(String letter) {
    setState(() {
      if (currentWord.length < targetWord.length && letter == targetWord[currentWord.length]) {
        currentWord.add(letter);
        if (currentWord.join('') == targetWord.join('')) {
          // Word completed
          _showSuccessDialog();
        }
      } else {
        errorCount++;
        if (errorCount >= hangmanImages.length) {
          _showGameOverDialog();
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You have made too many errors!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations"),
          content: Text("You have completed the word!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home2(),));
              },
            ),
          ],
        );
      },
    );
  }

  void _refreshPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => super.widget),
    );
  }

  void _resetGame() {
    setState(() {
      currentWord.clear();
      errorCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Stack(
              children: hangmanImages.asMap().entries.map((entry) {
                int idx = entry.key;
                String imagePath = entry.value;
                return Visibility(
                  visible: idx == 0 || errorCount >= idx,
                  child: Image.asset(
                    imagePath,
                    height: 200,
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: targetWord.map((letter) {
                int index = targetWord.indexOf(letter);
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: currentWord.length > index ? Colors.green : Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: errorCount > 0 && currentWord.length == index
                        ? Border.all(color: Colors.red, width: 3)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      currentWord.length > index ? currentWord[index] : '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 10),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: alphabet.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 2,
                mainAxisSpacing: 5,
                childAspectRatio: 1, // Aspect ratio of the items
              ),
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () => _onLetterPressed(alphabet[index]),
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.6),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        alphabet[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: lastAlphabet.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // Aspect ratio of the items
              ),
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () => _onLetterPressed(lastAlphabet[index]),
                  child: Container(
                    height: 35,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.6),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        lastAlphabet[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
