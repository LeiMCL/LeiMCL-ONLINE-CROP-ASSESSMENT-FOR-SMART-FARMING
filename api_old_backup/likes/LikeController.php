<?php
class LikeController
{
  private $conn;

  function __construct($conn)
  {
    $this->conn = $conn;
  }

  public function isPostLike($data)
  {
    $POSTID = $data->post_id;
    $USERID = $data->user_id;

    $checkLikeQry = $this->conn->prepare("SELECT * FROM post_likers WHERE user_id = (?) AND post_id = (?)");
    $checkLikeQry->bind_param("ii", $USERID, $POSTID);
    try {
      //code...
      $checkLikeQry->execute();

      if ($checkLikeQry->get_result()->fetch_assoc()) {
        echo json_encode(array("isLike" => "true"));
        exit();
      }
    } catch (\Throwable $th) {
      //throw $th;
    }
    echo json_encode(array("isLike" => "false"));
  }

  public function isCommentLike($data)
  {
    $COMMENTID = $data->comment_id;
    $USERID = $data->user_id;

    $checkLikeQry = $this->conn->prepare("SELECT * FROM comment_likers WHERE user_id = (?) AND comment_id = (?)");
    $checkLikeQry->bind_param("ii", $USERID, $COMMENTID);
    try {
      //code...
      $checkLikeQry->execute();

      if ($checkLikeQry->get_result()->fetch_assoc()) {
        echo json_encode(array("isLike" => "true"));
        exit();
      }
    } catch (\Throwable $th) {
      //throw $th;
    }
    echo json_encode(array("isLike" => "false"));
  }
}
