<?php
class PostController
{
  private $conn;

  function __construct($conn)
  {
    $this->conn = $conn;
  }

  // Get all posts
  public function getAllPosts()
  {
    // proceed to get all posts
    $getPostsQry = $this->conn->prepare("SELECT * FROM posts s1 INNER JOIN tbl_user s2
    ON s1.user_id = s2.user_id ORDER BY created_at DESC");
    // $getPostsQry->bind_param("", "");

    $allPostArray = array();
    try {
      //code...

      $getPostsQry->execute();
      $result = $getPostsQry->get_result();
      while ($row = $result->fetch_assoc()) {
        // get Comment count based on post
        $getCommentCountQry = $this->conn->prepare("SELECT COUNT(*) AS comment_count FROM comments s1 INNER JOIN posts s2 
        ON s1.post_id = s2.post_id WHERE s1.post_id = (?)");
        $getCommentCountQry->bind_param('i', $row['post_id']);
        $getCommentCountQry->execute();
        $resultCommentQry = $getCommentCountQry->get_result();
        $count = $resultCommentQry->fetch_assoc();

        array_push(
          $allPostArray,
          array(
            'post_id' => $row['post_id'],
            'user_id' => $row['user_id'],
            'content' => $row['content'],
            'name' => $row['name'],
            'like_count' => $row['like_count'],
            "comment_count" => $count['comment_count'],
            'created_at' => $row['created_at']
          )
        );
      }
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if (count($allPostArray) === 0) {
      echo json_encode(array('message' => 'No post available.'));
      exit();
    }

    echo json_encode($allPostArray);
  }

  // Get all posts of User using User ID
  public function getAllPostByUserId($userId)
  {
    // proceed to get all posts
    $getPostsQry = $this->conn->prepare("SELECT * FROM posts s1 INNER JOIN tbl_user s2
    ON s1.user_id = s2.user_id WHERE s1.user_id = (?) ORDER BY created_at DESC");
    $getPostsQry->bind_param("i", $userId);

    $allPostArray = array();

    try {
      //code...
      $getPostsQry->execute();
      $result = $getPostsQry->get_result();

      while ($post = $result->fetch_assoc()) {

        $getCommentCountQry = $this->conn->prepare("SELECT COUNT(*) AS comment_count FROM comments s1 INNER JOIN posts s2 
        ON s1.post_id = s2.post_id WHERE s1.post_id = (?)");
        $getCommentCountQry->bind_param('i', $post['post_id']);
        $getCommentCountQry->execute();
        $resultCommentQry = $getCommentCountQry->get_result();
        $count = $resultCommentQry->fetch_assoc();

        array_push(
          $allPostArray,
          array(
            'post_id' => $post['post_id'],
            'user_id' => $post['user_id'],
            'content' => $post['content'],
            'name' => $post['name'],
            'like_count' => $post['like_count'],
            'comment_count' => $count['comment_count'],
            'created_at' => $post['created_at']
          )
        );
      }
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if (count($allPostArray) === 0) {
      echo json_encode(array('message' => 'No post available.'));
      exit();
    }

    echo json_encode($allPostArray);
  }

  function getPostByPostId($postId)
  {
    $getPostQry = $this->conn->prepare("SELECT * FROM posts WHERE post_id = (?) ");
    $getPostQry->bind_param("i", $postId);

    try {
      //code...
      $getPostQry->execute();
      $post = $getPostQry->get_result()->fetch_assoc();

      echo json_encode(array(
        "post_id" => $post['post_id'],
        "content" => $post['content']
      ));
      exit();
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array(
        "message" => $th->getMessage()
      ));
      exit();
    }

    echo json_encode(array("message" => "No post found."));
  }

  public function postLike($USERID, $POSTID)
  {
    // check first if the user already like the post
    $checkLikeQry = $this->conn->prepare("SELECT * FROM post_likers WHERE user_id = (?) AND post_id = (?) ");
    $checkLikeQry->bind_param("ii", $USERID, $POSTID);
    $checkLikeQry->execute();

    $row = $checkLikeQry->get_result()->fetch_assoc();

    // if user already like the post delete the like
    if ($row !== null) {
      $deleteLikeQry = $this->conn->prepare("DELETE FROM post_likers WHERE user_id = (?) AND post_id = (?) ");
      $deleteLikeQry->bind_param("ii", $USERID, $POSTID);
      $deleteLikeQry->execute();
      exit();
    }

    // proceed to create a like
    $createLikeQry = $this->conn->prepare("INSERT INTO post_likers (user_id, post_id) VALUES (?, ?)");
    $createLikeQry->bind_param("ii", $USERID, $POSTID);

    try {
      //code...
      $createLikeQry->execute();
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($createLikeQry->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    // create a notification that the user like the post

    // get the info of liker
    $getLikerQuery = $this->conn->prepare("SELECT name FROM tbl_user WHERE user_id = (?)");
    $getLikerQuery->bind_param('i', $USERID);
    $getLikerQuery->execute();

    $likerInfo = $getLikerQuery->get_result()->fetch_assoc();

    // get the info of the owner of post
    $getOwnerInfoQry = $this->conn->prepare("SELECT s1.user_id, name FROM tbl_user AS s1 INNER JOIN posts AS s2 
    ON s1.user_id = s2.user_id WHERE s2.post_id = (?)");
    $getOwnerInfoQry->bind_param('i', $POSTID);
    $getOwnerInfoQry->execute();

    $ownerInfo = $getOwnerInfoQry->get_result()->fetch_assoc();

    // if owner liked his/her own post don't add notification
    echo json_encode(array("user" => $USERID, "owner" => $ownerInfo['user_id']));
    if ($USERID == $ownerInfo['user_id']) {
      exit();
      return;
    }

    // create the notification
    $message = $likerInfo['name'] . " liked your Post.";

    $createNotificationQry = $this->conn->prepare("INSERT INTO notifications (user_id, content) VALUES (?, ?)");
    $createNotificationQry->bind_param('is', $ownerInfo['user_id'], $message);
    $createNotificationQry->execute();
  }

  public function createPost($data)
  {
    $USERID = $data->user_id;
    $CONTENT = $data->content;

    $createPostQry = $this->conn->prepare("INSERT INTO posts (user_id, content) VALUES (?, ?)");
    $createPostQry->bind_param("is", $USERID, $CONTENT);

    try {
      //code...
      $createPostQry->execute();
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($createPostQry->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    echo json_encode(array(
      'message' => 'New Post Created!'
    ));
  }

  public function editPost($data)
  {
    $POSTID = $data->post_id;
    $CONTENT = $data->content;

    $updatePostQry = $this->conn->prepare("UPDATE posts SET content = (?) 
    WHERE post_id = (?)");
    $updatePostQry->bind_param("si", $CONTENT, $POSTID);

    try {
      //code...
      $updatePostQry->execute();
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($updatePostQry->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    echo json_encode(array(
      'message' => 'Post Updated!'
    ));
  }

  public function deletePost($POSTID)
  {

    $updatePostQry = $this->conn->prepare("DELETE FROM posts WHERE post_id = (?)");
    $updatePostQry->bind_param("i", $POSTID);

    try {
      //code...
      $updatePostQry->execute();
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($updatePostQry->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    echo json_encode(array(
      'message' => 'Post Deleted!'
    ));
  }
}
