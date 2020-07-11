import 'package:flutter/material.dart';
import 'package:oodles/provider/users_provider.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  var _isEdit = false;
  final TextEditingController _searchController = new TextEditingController();
  var focusNode = new FocusNode();

  Future<void> _submitData() async {
    final enteredText = _searchController.text;
    await Provider.of<UsersProvider>(context, listen: false)
        .filterUsersOnNameBases(enteredText);
  }

  Future<void> _loadData() async {
    _searchController.text = '';
    await Provider.of<UsersProvider>(context, listen: false).setUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isEdit
            ? TextField(
                decoration: InputDecoration(labelText: 'Search'),
                controller: _searchController,
                keyboardType: TextInputType.text,
                focusNode: focusNode,
                onChanged: (val) => _submitData(),
              )
            : null,
        actions: [
          _isEdit
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEdit = false;
                      _loadData();
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isEdit = true;
                      focusNode.requestFocus();
                    });
                  }),
        ],
      ),
      body: Consumer<UsersProvider>(
          child: Center(
            child: CircularProgressIndicator(),
          ),
          builder: (ctx, data, _) {
            return ListView.builder(
              itemCount: data.items.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  margin: index.isEven
                      ? EdgeInsets.only(right: 30)
                      : EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name : ${data.items[index].name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Email : ${data.items[index].email}',
                                  // style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                            '${data.items[index].address.suite},${data.items[index].address.street},${data.items[index].address.city},${data.items[index].address.zipcode},'),
                        SizedBox(
                          height: 2,
                        ),
                        Text('Phone : ${data.items[index].phone}'),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            ' ${data.items[index].website}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
