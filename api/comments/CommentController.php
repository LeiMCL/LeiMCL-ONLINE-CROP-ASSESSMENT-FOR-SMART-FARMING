<?php
class CommentController
{
  private $conn;

  function __construct($conn)
  {
    $this->conn = $conn;
  }

  public function getAllCommentByPostId($postId)
  {

    // proceed to get all comments
    $getCommentQry = $this->conn->prepare("SELECT * FROM comments s1 INNER JOIN tbl_user s2
    ON s1.user_id = s2.user_id WHERE post_id = (?) ORDER BY created_at ASC");
    $getCommentQry->bind_param("i", $postId);

    $allCommentArray = array();

    try {
      //code...
      $getCommentQry->execute();
      $result = $getCommentQry->get_result();

      while ($comment = $result->fetch_assoc()) {
        array_push(
          $allCommentArray,
          array(
            'comment_id' => $comment['comment_id'],
            'user_id' => $comment['user_id'],
            'post_id' => $comment['post_id'],
            'name' => $comment['name'],
            'content' => $comment['content'],
            'like_count' => $comment['like_count'],
            'created_at' => $comment['created_at']
          )
        );
      }
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if (count($allCommentArray) === 0) {
      echo json_encode(array('message' => 'No comments available.'));
      exit();
    }

    echo json_encode($allCommentArray);
  }

  public function postComment($data)
  {
    $USERID = $data->user_id;
    $POSTID = $data->post_id;
    $CONTENT = $data->content;

    $createCommentQry = $this->conn->prepare("INSERT INTO comments (user_id, post_id, content) VALUES (?, ?, ?)");
    $createCommentQry->bind_param("iis", $USERID, $POSTID, $CONTENT);

    try {
      //code...
      $createCommentQry->execute();
      $commentId = $createCommentQry->insert_id;
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($createCommentQry->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    echo json_encode(array(
      'message' => 'New Comment Posted!',
      'comment_id' => $commentId
    ));

    // create a notification that the user comment to the post

    // get the info of commenter
    $getCommenterQry = $this->conn->prepare("SELECT name FROM tbl_user WHERE user_id = (?)");
    $getCommenterQry->bind_param('i', $USERID);
    $getCommenterQry->execute();

    $commenterInfo = $getCommenterQry->get_result()->fetch_assoc();

    // get the info of the owner of post
    $getOwnerInfoQry = $this->conn->prepare("SELECT s1.user_id, name FROM tbl_user AS s1 INNER JOIN posts AS s2 
    ON s1.user_id = s2.user_id WHERE s2.post_id = (?)");
    $getOwnerInfoQry->bind_param('i', $POSTID);
    $getOwnerInfoQry->execute();

    $ownerInfo = $getOwnerInfoQry->get_result()->fetch_assoc();

    // if owner commented on his/her own post don't add notification
    if ($USERID == $ownerInfo['user_id']) {
      exit();
    }

    // create the notification
    // $message = $commenterInfo['name'] . " commented on your Post.";

    // $createNotificationQry = $this->conn->prepare("INSERT INTO notifications (user_id, content) VALUES (?, ?)");
    // $createNotificationQry->bind_param('is', $ownerInfo['user_id'], $message);
    // $createNotificationQry->execute();
  }

  public function commentLike($userId, $commentId)
  {
    // check first if the user already like the post
    $checkLikeQry = $this->conn->prepare("SELECT * FROM comment_likers WHERE user_id = (?) AND comment_id = (?) ");
    $checkLikeQry->bind_param("ii", $userId, $commentId);
    $checkLikeQry->execute();

    $row = $checkLikeQry->get_result()->fetch_assoc();

    // if user already like the post delete the like
    if ($row !== null) {
      $deleteLikeQry = $this->conn->prepare("DELETE FROM comment_likers WHERE user_id = (?) AND comment_id = (?) ");
      $deleteLikeQry->bind_param("ii", $userId, $commentId);
      $deleteLikeQry->execute();
      exit();
    }

    // proceed to create a like
    $createLikeQry = $this->conn->prepare("INSERT INTO comment_likers (user_id, comment_id) VALUES (?, ?)");
    $createLikeQry->bind_param("ii", $userId, $commentId);

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

    // create a notification that the user like the comment

    // get the info of liker
    $getLikerQuery = $this->conn->prepare("SELECT name FROM tbl_user WHERE user_id = (?)");
    $getLikerQuery->bind_param('i', $userId);
    $getLikerQuery->execute();

    $likerInfo = $getLikerQuery->get_result()->fetch_assoc();

    // get the info of the owner of comment
    $getOwnerInfoQry = $this->conn->prepare("SELECT s1.user_id, name FROM tbl_user AS s1 INNER JOIN comments AS s2 
    ON s1.user_id = s2.user_id WHERE s2.comment_id = (?)");
    $getOwnerInfoQry->bind_param('i', $commentId);
    $getOwnerInfoQry->execute();

    $ownerInfo = $getOwnerInfoQry->get_result()->fetch_assoc();

    // if owner liked his/her own comment don't add notification
    if ($userId == $ownerInfo['user_id']) {
      exit();
    }

    // create the notification
    // $message = $likerInfo['name'] . " liked your Comment.";

    // $createNotificationQry = $this->conn->prepare("INSERT INTO notifications (user_id, content) VALUES (?, ?)");
    // $createNotificationQry->bind_param('is', $ownerInfo['user_id'], $message);
    // $createNotificationQry->execute();
  }
}
