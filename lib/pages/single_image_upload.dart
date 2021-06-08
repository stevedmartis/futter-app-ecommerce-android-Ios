import 'dart:io';

import 'package:australti_ecommerce_app/services/product.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_bloc.dart';
import 'package:australti_ecommerce_app/store_product_concept/store_product_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SingleImageUpload extends StatefulWidget {
  SingleImageUpload({this.images, this.isEdit = false});
  final List images;
  final bool isEdit;
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildGridView(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildGridView() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.images.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = widget.images[index];
          return Container(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.file(
                    uploadModel.imageFile,
                    width: 150,
                    height: 150,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 30,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          widget.images
                              .replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (widget.images[index] is ImageProduct) {
          ImageProduct uploadModel = widget.images[index];

          return Container(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Image.network(
                    uploadModel.url,
                    width: 150,
                    height: 150,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 30,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          widget.images
                              .replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            width: 150,
            height: 150,
            child: Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddImageClick(index);
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future _onAddImageClick(int index) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 680,
      maxWidth: 1800,
    );

    final File file = File(pickedFile.path);

    setState(() {
      getFileImage(index, file);
    });
  }

  void getFileImage(int index, File file) async {
//    var dir = await path_provider.getTemporaryDirectory();

    ImageUploadModel imageUpload = new ImageUploadModel();
    imageUpload.isUploaded = false;
    imageUpload.uploading = false;
    imageUpload.imageFile = file;
    imageUpload.imageUrl = '';
    widget.images.replaceRange(index, index + 1, [imageUpload]);

    final productService =
        Provider.of<StoreProductService>(context, listen: false);

    final fileMultiPart = await productService.multiPartFileImage(file);

    tabsViewScrollBLoC.addImageProduct(fileMultiPart);
  }
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
