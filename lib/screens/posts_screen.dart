import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_blog_laravel/controllers/post_controller.dart';
import 'package:simple_blog_laravel/controllers/user_controller.dart';
import 'package:simple_blog_laravel/services/post_service.dart';
import 'package:simple_blog_laravel/widgets/post_widget.dart';

class PostsScreen extends StatelessWidget {
  PostsScreen({Key? key}) : super(key: key);
  final service = PostService();
  final userController = Get.find<UserController>();
  final postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.amber,
      onRefresh: () {
        return postController.getPosts();
      },
      child: GetBuilder<PostController>(builder: (builder) {
        return GetBuilder<UserController>(
            builder: (builder) => Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: postController.posts.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: postController.posts.length,
                          itemBuilder: (builder, index) => PostWidget(
                            id: postController.posts[index]["id"],
                            body: postController.posts[index]["body"],
                            image: postController.posts[index]["image"],
                            likesCount: postController.posts[index]
                                ["likes_count"],
                            commentsCount: postController.posts[index]
                                ["comments_count"],
                            userImage: postController.posts[index]["user"]["image"],
                            userName: isProperty(index) ? userController.user.value.name :postController.posts[index]["user"]
                                ["name"],
                            isProperty: isProperty(index),
                            selfLiked: postController.posts[index]["likes"].length>0,
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 20,
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No posts found",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ));
      }),
    );
  }


  bool isProperty(index){
    //print(userController.user.value.name);
    return postController.posts[index]["user_id"] == userController.user.value.id;
  }
}

/*
FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            final posts = postController.posts;
            return GetBuilder<UserController>(
                builder: (builder) => Container(
                  padding: const EdgeInsets.only(top:20, left: 20, right: 20),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: posts.length,
                    itemBuilder: (builder,index) => PostWidget(
                      id: posts[index]["id"],
                      body: posts[index]["body"],
                      likesCount: posts[index]["likes_count"],
                      commentsCount: posts[index]["comments_count"],
                      userName: posts[index]["user"]["name"],
                      isProperty: posts[index]["user_id"] == userController.user.value.id,
                    ), separatorBuilder:
                      (BuildContext context, int index) => const Divider(height: 20,),
                  ),
                )
            );
          }
          else{
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              )
            );
          }
        },
      )
 */
