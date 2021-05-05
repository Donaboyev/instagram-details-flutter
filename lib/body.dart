import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: noInternet
          ? Container(
              child: Center(
                child: Image.asset(
                  'assets/images/no_internet.png',
                  width: 300,
                  height: 300,
                ),
              ),
            )
          : Container(
              child: found
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(80, 10, 80, 30),
                          child: ClipOval(
                            child: FadeInImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(dpUrl),
                              placeholder:
                                  AssetImage('assets/images/loading_image.gif'),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '$posts post(s)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$followers follower(s)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$following following',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    isPrivate
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.blue,
                                          )
                                        : Icon(Icons.cancel),
                                    Text('Is private'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    isVerified
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.blue,
                                          )
                                        : Icon(Icons.cancel),
                                    Text('Is verified'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$fullName',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$biography',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              child: externalUrl == 'null'
                                  ? Text('')
                                  : Text(
                                      '$externalUrl',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                              onTap: () => launch('$externalUrl'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Image.asset(
                        'assets/images/not_found.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
              margin: EdgeInsets.fromLTRB(0, 56, 0, 0),
            ),
    );
  }
}
