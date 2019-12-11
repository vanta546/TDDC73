import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'https://api.github.com/graphql',
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer 827ccf072316ad3df42d8ca4b2313a4236f21c63',
      // OR
      // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    );

    final Link link = authLink.concat(httpLink);

    //Notifying the client whenever a value is changed
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );


    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MyHomePage(
          title: 'Flutter Demo He',
        ),
      ),
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

  String _language = "Python";

  //Hur får man ut trending repos?
  String readTrendingRepos = """
  query ReadTrendingRepos(\$nRepositories: Int!, \$query: String!){
    search(query: \$query, type: REPOSITORY, last: \$nRepositories) {
      nodes {
        ... on Repository {
          id
          name
          description
          forkCount
          stargazers {
            totalCount
          }
          owner {
            login
          }
          commitComments {
            totalCount
          }
          licenseInfo {
            name
          }
        }
      }
    }
  }
  """;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6340B2),
        title: Center(
          child:
            DropdownButton<String>(
            value: _language,
            icon: Icon(
              IconData(58131, fontFamily: 'MaterialIcons'),
              color: Colors.white,
            ),
            items: <String>['Python','Javascript','Java']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.black),


                ),
              );
            })
                .toList(),
            onChanged: (String newLanguage) {
              setState(() {
                _language = newLanguage;
              });
            },
          ),
        ),
      ),

      body:
          Container(
            color: Color(0xFFE6E6E6),
            child:
              Query(
                  options: QueryOptions(
                    document: readTrendingRepos, // this is the query string you just created
                    variables: {
                      'nRepositories': 10,
                      'query': 'language:' + _language,
                    },
                    pollInterval: 10,
                  ),
                  builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
                    if (result.errors != null) {
                      return Text(result.errors.toString());
                    }

                    if (result.loading) {
                      return Text('Loading');
                    }

                    // it can be either Map or List
                    List repositories = result.data['search']['nodes'];

                    return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          final repository = repositories[index];

                          return GestureDetector(
                            onTap: () {
                              print("Clicked");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RepoPage(
                                    name: repository['name'],
                                    description: repository['description'],
                                    commits: repository['commitComments']['totalCount'].toString(),
                                    license: repository['licenseInfo']['name'],
                                  )),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 8, right: 8, left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 5, top: 10),
                                    child:
                                      Text(
                                        repository['name'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 5),
                                    child:
                                      Text(
                                        repository['owner']['login'] + '/' + repository['name'],
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 5),
                                    child:
                                    Text(
                                        repository['description']
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(3.0),
                                        decoration:
                                        BoxDecoration(
                                          color: Color(0xFF4A3A4C),
                                        ),
                                        child: 
                                          Text(
                                            "Forks " + repository['forkCount'].toString() ,
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(3.0),
                                        decoration:
                                          BoxDecoration(
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5.0)),
                                            color: Color(0xFFE5B73C),
                                          ),
                                        child:
                                          Text(
                                            "Stars " + repository['stargazers']['totalCount'].toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
          ),
    );
  }
}

class RepoPage extends StatefulWidget {
  RepoPage({Key key, this.name, this.description, this.license, this.commits}) : super(key: key);

  final name, description, license, commits;

  @override
  _RepoPageState createState() => _RepoPageState();
}

class _RepoPageState extends State<RepoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
          AppBar(
            backgroundColor: Color(0xFF6340B2),
            title: Text(
              widget.name,
            ),
          ),
      body:
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child:
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("License"),
                    Text("Commits"),
                    Text("Branches"),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      widget.license,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      widget.commits,
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "100",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }
}
