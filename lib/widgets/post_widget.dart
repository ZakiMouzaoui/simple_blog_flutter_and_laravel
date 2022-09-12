import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/constant.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/screens/edit_post_screen.dart';
import 'package:simple_blog_laravel/widgets/show_snackbar.dart';

import '../models/post.dart';

class PostWidget extends StatelessWidget {
  const PostWidget(
      {Key? key,
        required this.body,
        this.image,
        required this.likesCount,
        required this.commentsCount,
        required this.userName,
        required this.isProperty,
        required this.id,
        required this.userImage,
        required this.selfLiked,
      })
      : super(key: key);

  final int id;
  final String body;
  final String? image;
  final int likesCount;
  final int commentsCount;
  final String userName;
  final bool isProperty;
  final String? userImage;
  final bool selfLiked;

  @override
  Widget build(BuildContext context) {
    final postController = Get.find<PostController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black12,
                  child: CachedNetworkImage(
                      imageUrl: userImage != null ? userImage! : defaultAvatarURL,
                      imageBuilder: (context,provider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: provider,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      placeholder: (context,url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                      errorWidget: (context,url,error) => const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.amber,
                        ),
                      ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
              if (isProperty) PopupMenuButton(itemBuilder: (BuildContext context) =>
              [
                PopupMenuItem(
                  value: "edit",
                  child: Row(
                    children:
                    const [
                      Text("Edit"),
                      Icon(Icons.edit,color: Colors.blueAccent,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    children:
                    const [
                      Text("Delete"),
                      Icon(Icons.delete,color: Colors.redAccent,)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),

                  onTap: ()async{
                    final apiResponse = await postController.deletePost(id);
                    if(apiResponse.error == null){
                      showSnackBar("Post details", "Post deleted");
                    }
                  },
                )
              ],
                onSelected: (_value){
                  if(_value=="edit"){
                    Get.to(()=> EditPostScreen(
                        post: Post(
                            id: id,
                            body: body,
                            image: image
                        )
                    ));
                  }
                },
              ) else const SizedBox()
          ]),
          const SizedBox(
            height: 20,
          ),
          Text(body),
          const SizedBox(
            height: 5,
          ),
          image != null ?
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            width: double.infinity,
            height: 250,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: image!,
              placeholder: (context,url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error_outline,color: Colors.amber,),
                  SizedBox(height: 5,),
                  Text("Could not load the image")
                ],
              ),
            ),
          ):const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: ()async{
                      postController.likeOrUnlikePost(id);
                    },
                    child: selfLiked ? const Icon(
                      Icons.favorite,
                      color: Colors.amber,
                    ) : const Icon(
                        Icons.favorite_border_outlined
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(likesCount.toString())
                ],
              ),
              const Divider(
                thickness: 10,
                color: Colors.white,
              ),
              Row(
                children: [
                  const Icon(Icons.comment_rounded),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(commentsCount.toString())
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
