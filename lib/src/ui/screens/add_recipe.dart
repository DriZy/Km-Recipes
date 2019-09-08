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
  final _formKey = GlobalKey();
  File galleryFile;

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
        height: 200.0,
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
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                               icon: const Icon(Icons.edit),
                               labelText: 'Type'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter recipe type';
                              }
                            },
                            // onSaved: (val) =>
                            //     setState(() => _user.firstName = val),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.mode_edit),
                              labelText: 'Name'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter recipe name.';
                              }
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.timer),
                              labelText: 'Duration'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter recipe Duration.';
                              }
                            },
                          ),
                          displaySelectedFile(galleryFile),
                          RaisedButton(
                            child: new Text('Select Recipe Image'),
                            onPressed: imageSelectorGallery,
                          ),
                          // onSaved: (val) =>
                          //     setState(() => _user.lastName = val)),
                          // Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 16.0, horizontal: 16.0),
                          //     child: RaisedButton(
                          //         onPressed: () {
                          //           final form = _formKey.currentState;
                          //           if (form.validate()) {
                          //             form.save();
                          //             _user.save();
                          //             _showDialog(context);
                          //           }
                          //         },
                          //         child: Text('Save'))),
                        ])))));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}
