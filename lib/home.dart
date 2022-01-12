import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'body.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const historyLength = 5;

  List<String> _searchHistory = [];
  bool isSearching = false;
  String? username;
  late List<String> filteredSearchHistory;
  late FloatingSearchBarController controller;

  List<String> filterSearchTerms({
    String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) async {
    if (term.isEmpty) {
      return;
    }
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getHttp(String username, BuildContext context) async {
    found = false;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isSearching = false;
        noInternet = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check your internet connection')));
    } else {
      try {
        Response response =
            await Dio().get('https://www.instagram.com/$username/?__a=1');
        String statusCode = response.statusCode.toString();
        if (statusCode == '200') {
          debugPrint('======> 200: ${response.data}');
          setState(() {
            found = true;
            noInternet = false;

            dpUrl = response.data['graphql']['user']['profile_pic_url_hd'];
            posts = response.data['graphql']['user']
                    ['edge_owner_to_timeline_media']['count']
                .toString();
            followers = response.data["graphql"]["user"]["edge_followed_by"]
                    ["count"]
                .toString();
            following = response.data["graphql"]["user"]["edge_follow"]["count"]
                .toString();
            isPrivate = response.data["graphql"]["user"]["is_private"];
            isVerified = response.data["graphql"]["user"]["is_verified"];
            fullName = response.data["graphql"]["user"]["full_name"].toString();
            biography =
                response.data["graphql"]["user"]["biography"].toString();
            externalUrl =
                response.data["graphql"]["user"]["external_url"].toString();

            setState(() {
              isSearching = false;
            });
          });
        }
      } catch (e) {
        debugPrint('======> ex: $e');
        setState(() {
          isSearching = false;
          noInternet = false;
          found = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid username')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        body: username == null
            ? Center(
                child: Image.asset(
                  'assets/images/search_man.png',
                  width: 200,
                  height: 400,
                  scale: 1,
                ),
              )
            : Scaffold(
                body: isSearching == true
                    ? Center(
                        child: Image.asset('assets/images/loading_image.gif'),
                      )
                    : Body(),
              ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          username ?? 'Instagram profile finder',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Enter instagram username',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query.trim());
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query.trim());
            username = query.trim();
            getHttp(username!, context);
            isSearching = !isSearching;
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          username = controller.query;
                          getHttp(username!, context);
                          isSearching = !isSearching;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Icon(Icons.history),
                              trailing: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  username = term;
                                  getHttp(username!, context);
                                  isSearching = !isSearching;
                                });
                                controller.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
