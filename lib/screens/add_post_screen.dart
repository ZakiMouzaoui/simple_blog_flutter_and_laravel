import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/screens/home_screen.dart';
import 'package:simple_blog_laravel/widgets/show_snackbar.dart';
import 'package:simple_blog_laravel/widgets/text_button_widget.dart';
import 'package:simple_blog_laravel/widgets/text_field_widget.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);

  final _picker = ImagePicker();
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    final _bodyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    postController.imageFile.value=File("");

    return WillPopScope(

      onWillPop: () async{
        postController.resetFile();
        return true;
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Post"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GetBuilder<PostController>(
                      builder: (_) => GestureDetector(
                        onTap: (){
                          getImage();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              image: postController.imageFile.value.path != "" ? DecorationImage(
                                  image: FileImage(postController.imageFile.value),
                                  fit: BoxFit.cover
                              ) : null
                          ),
                          child: Center(
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.image, size: 40,),
                              onPressed: () {
                                getImage();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    TextFieldWidget(
                        maxLines: 10,
                        labelText: "Post Body",
                        controller: _bodyController,
                        validation: (_value) => _value!.isEmpty
                        ? "The body field is required" : null
                    ),
                    const SizedBox(height: 20,),
                    TextButtonWidget(
                      btnText: "Post",
                      onTap: () async{
                        if(_formKey.currentState!.validate()){
                          // Add the post
                          final apiResponse = await postController.addPost(_bodyController.text.trim(), postController.imageFile.value);
                          if(apiResponse.error == null){
                            showSnackBar("Post details", "Post added");
                            Get.offAll(()=>HomeScreen());
                          }
                          else{
                            showSnackBar("Response details", apiResponse.error);
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }

  Future getImage() async{
    final _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(_pickedFile != null){
      postController.getImage(_pickedFile);
    }
  }
}
