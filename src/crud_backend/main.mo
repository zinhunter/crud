import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor {
  type Post = {
    message: Text;
    image: Text;
  };

  stable var postId: Nat = 0;
  let posts = HashMap.HashMap<Text, Post>(0, Text.equal, Text.hash);

  private func generatePostId(): Text {
    postId += 1;
    return Nat.toText(postId);
  };

  public func createPost(message: Text, image: Text) {
    let post: Post = { message; image };
    let key = generatePostId();

    posts.put(key, post);
    Debug.print("Post successfully created with ID: " # key);
  };

  public query func getPost(key: Text): async ?Post {
    posts.get(key);
  };

  public query func getPosts(): async [(Text, Post)]{
    let postIter: Iter.Iter<(Text, Post)> = posts.entries();
    Iter.toArray(postIter)
  };

  public func updatePost(key: Text, message: Text): async Bool {
    let post: ?Post = posts.get(key);

    switch(post) {
      case (null) {
        Debug.print("Cannot find post.");
        return false;
      };
      case(?currentPost) {
        let newPost: Post = { message; image = currentPost.image };
        posts.put(key, newPost);

        Debug.print("Post updated.");
        return true;
      };
    };
  };

  public func deletePost(key: Text): async Bool {
    let post: ?Post = posts.get(key);

    switch(post) {
      case (null) {
        Debug.print("Cannot find post.");
        return false;
      };
      case(_) {
        ignore posts.remove(key);

        Debug.print("Post deleted.");
        return true;
      };
    };
  };
};
