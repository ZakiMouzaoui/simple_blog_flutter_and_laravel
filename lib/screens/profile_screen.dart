import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_laravel/constant.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/widgets/show_snackbar.dart';
import 'package:simple_blog_laravel/widgets/text_button_widget.dart';
import 'package:simple_blog_laravel/widgets/text_field_widget.dart';

import '../controllers/post_controller.dart';


class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final _picker = ImagePicker();
  final _userController = Get.find<UserController>();
  final _postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: _userController.user.value.name);
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      getImage();
                    },
                    child: GetBuilder<UserController>(
                      builder: (_) => CircleAvatar(
                        radius: 50,
                        child: _userController.imageFile.value.path != ""
                          ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: FileImage(_userController.imageFile.value),
                                  fit: BoxFit.cover
                              )
                          ),
                        ) : CachedNetworkImage(
                          imageUrl: _userController.user.value.image != null
                              ? _userController.user.value.image! : defaultAvatarURL,
                          imageBuilder: (context, provider) => Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                    image: provider,
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_outline,color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80,),
                  TextFieldWidget(
                      labelText: "Name",
                      controller: _nameController,
                      validation: (_value) => _nameController.text.trim().isEmpty
                          ? "The name field is required"
                          : null
                  ),
                  const SizedBox(height: 20,),
                  TextButtonWidget(
                      onTap: ()async{
                        if(_formKey.currentState!.validate()){
                          final apiResponse = await _userController.updateProfile(
                              _nameController.text.trim(),
                              _userController.imageFile.value
                          );
                          if(apiResponse.error == null){
                            showSnackBar("User status", "Profile updated");
                            _postController.changePageIndex(0);
                          }
                        }
                      },
                      btnText: "Edit"
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }

  Future getImage() async{
    final _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(_pickedFile != null){
      _userController.getImage(_pickedFile);
    }
  }
}
