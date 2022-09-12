import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/models/post.dart';
import 'package:simple_blog_laravel/screens/home_screen.dart';
import 'package:simple_blog_laravel/widgets/show_snackbar.dart';
import 'package:simple_blog_laravel/widgets/text_button_widget.dart';
import 'package:simple_blog_laravel/widgets/text_field_widget.dart';

class EditPostScreen extends StatelessWidget {
  EditPostScreen({Key? key, required this.post}) : super(key: key);

  final _picker = ImagePicker();
  final postController = Get.find<PostController>();
  final Post post;

  @override
  Widget build(BuildContext context) {
    final _bodyController = TextEditingController(text: post.body);
    final _formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async {
        postController.resetFile();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Post"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GetBuilder<PostController>(
                    builder: (_) => SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Stack(children: [
                          postController.imageFile.value.path != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(
                                              postController.imageFile.value),
                                          fit: BoxFit.cover)),
                                )
                              : post.image != null
                                  ? CachedNetworkImage(
                                      imageUrl: post.image!,
                                      errorWidget: (context, url, error) =>
                                          Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        children: const [
                                            SizedBox(height: 100,),
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Could not load the image")
                                        ],
                                      ),
                                          ),
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.amber,
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover)),
                                      ),
                                    )
                                  : const SizedBox(),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.image,
                                  size: 40,
                                ),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFieldWidget(
                      maxLines: 10,
                      labelText: "Post Body",
                      controller: _bodyController,
                      validation: (_value) => _value!.isEmpty
                          ? "The body field is required"
                          : null),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButtonWidget(
                    btnText: "Post",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        // Add the post
                        final apiResponse = await postController.editPost(
                            post.id!,
                            _bodyController.text.trim(),
                            postController.imageFile.value);
                        if (apiResponse.error == null) {
                          showSnackBar("Post details", "Post edited");
                          Get.offAll(() => HomeScreen());
                        } else {
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

  Future getImage() async {
    final _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      postController.getImage(_pickedFile);
    }
  }
}
