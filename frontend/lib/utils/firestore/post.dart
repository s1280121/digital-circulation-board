import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/post.dart';

class PostFireStore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');

  static Future<dynamic> addPost(Post newpost) async {
    try{
      final CollectionReference _userPosts = _firestoreInstance.collection('users').doc(newpost.postAccountId).collection('my_posts');
      var result = await posts.add({
        'content': newpost.content,
        'post_account_id': newpost.postAccountId,
        'created_time': Timestamp.now(),
      });
      _userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
      });
      print('投稿完了');
      return true;
    } on FirebaseException catch(e){
      print('投稿エラー: $e');
      return false;
    }
  }
  //static Future<List<Post>> getPostsFromIds(
      //)
}