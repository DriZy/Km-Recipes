import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();

  File galleryFile;

  List<String> ingredients = [];
  List<String> preparation = [];

  // TextEditingController _controller = TextEditingController();

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {});
    }

    Widget displaySelectedFile(File file) {
      return new SizedBox(
        height: 150.0,
        width: 300.0,
//child: new Card(child: new Text(''+galleryFile.toString())),
//child: new Image.file(galleryFile),
        child: file == null
            ? new Text('No recipe image selected!!')
            : new Image.file(file),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Add A Recipe",
              style: TextStyle(fontSize: 30, color: Colors.orange))),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.edit), labelText: 'Type'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter recipe type';
                    }
                  },
                  onSaved: (val) {
                    print(val);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      icon: const Icon(Icons.mode_edit), labelText: 'Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter recipe name.';
                    }
                  },
                  onSaved: (val) {
                    print(val);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.timer), labelText: 'Duration'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter recipe Duration.';
                    }
                  },
                  onSaved: (val) {
                    print(val);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ingredients',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center),
                ),
                Column(
                  children: ingredients.reversed.map((item) {
                    return Dismissible(
                      key: Key(item),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          ingredients.remove(item);
                        });
                      },
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter igredient';
                          }
                        },
                        onSaved: (val) {
                          print(val);
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          labelText: 'Enter ingredient',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              debugPrint('222');
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          child: new Text('Clear All',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              ingredients.clear();
                            });
                          },
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: new Text('Add Ingredient',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              ingredients.add('');
                            });
                          },
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Preparation Steps',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center),
                ),
                Column(
                  children: preparation.reversed.map((item) {
                    return Dismissible(
                        key: Key(item),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            preparation.remove(item);
                          });
                        },
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter preparayory step';
                            }
                          },
                          onSaved: (val) {
                            print(val);
                          },
                          decoration: InputDecoration(
                              icon: Icon(Icons.edit),
                              labelText: 'Enter preparatory step',
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    debugPrint('222');
                                  })),
                        ));
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          child: new Text('Clear All',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              preparation.clear();
                            });
                          },
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: new Text('Add Preparation',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              preparation.add('');
                            });
                          },
                        ),
                      ]),
                ),
                displaySelectedFile(galleryFile),
                RaisedButton(
                  child: new Text('Select Recipe Image'),
                  onPressed: imageSelectorGallery,
                ),
                // onSaved: (val) =>
                //     setState(() => _user.lastName = val)
                //),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _showDialog(context);
                      }
                    },
                    child: Text('Add Recipe'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}
