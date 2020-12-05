import 'package:flutter/material.dart';
import 'package:whoisit/screens/input_view.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Who is it? Cat or Dog',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.navigate_next_outlined,
                                color: Colors.white,
                                size: 38.0,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => InputScreen()));
                              })
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70.0),
                    ),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://mir-s3-cdn-cf.behance.net/project_modules/fs/66639267962641.5b4cd7217d1a7.png'))),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 100.0),
                width: double.infinity,
                height: 200.0,
                child: Image.asset('assets/logo.png'),
              )
            ],
          )
        ],
      ),
    );
  }
}
