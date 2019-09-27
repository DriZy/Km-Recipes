import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();

  String type, name, duration, url;
  List<String> ingredients = [];
  List<String> preparation = [];

  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    Widget enableUpload() {
      return Container(
        child: Column(
          children: <Widget>[
            Image.file(sampleImage, height: 170.0, width: 200.0),
          ],
        ),
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
                  key: Key('type'),
                  decoration: InputDecoration(
                      icon: const Icon(Icons.edit), labelText: 'Type'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter recipe type';
                    }
                  },
                  onSaved: (value) {
                    type = value;
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
                  onSaved: (value) {
                    name = value;
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
                    duration = value;
                  },
                  onSaved: (duration) {
                    duration = duration;
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
                        onSaved: (value) {
                          ingredients.add(value);
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          labelText: 'Enter ingredient',
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
                            setState(() {
                              if (val.isEmpty) {
                                preparation.remove(val);
                              }
                              preparation.add(val);
                            });
                          },
                          decoration: InputDecoration(
                            icon: Icon(Icons.edit),
                            labelText: 'Enter preparatory step',
                          ),
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: sampleImage == null
                      ? Text('Select an image')
                      : enableUpload(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: new Text('Select Recipe Image'),
                          onPressed: getImage,
                        ),
                        RaisedButton(
                            child: new Text('Save Image'),
                            onPressed: () {
                              Image.file(sampleImage);
                              StorageReference firebaseStorageRef =
                                  FirebaseStorage.instance
                                      .ref()
                                      .child(name);
                              final StorageUploadTask task =
                                  firebaseStorageRef.putFile(sampleImage);
                               final url = firebaseStorageRef.getDownloadURL();
                              print(url);
                            }),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _formData();
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

  // _uploadImage() {
  //   Image.file(sampleImage);
  //   StorageReference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('myimage.jpg');
  //   final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
  // }

  _formData() {
    DocumentReference ds = Firestore.instance.collection('recipes').document();
    Map<String, dynamic> recipes = {
      "type": type,
      "name": name,
      "duration": duration,
      "ingredients": ingredients,
      "preparation": preparation,
      "imageURL": url,
    };
    ds.setData(recipes).whenComplete(() {
      print('Recipe created');
      print(recipes);
    });
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}
