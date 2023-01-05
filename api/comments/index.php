<?php
include '../../db_config/ConnectDB.php';
include './CommentController.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header('Content-type: application/json');

$obj = new ConnectDB();
$conn = $obj->connect();
$commentController = new CommentController($conn);

// send an error message if request method is not GET
if ($_SERVER["REQUEST_METHOD"] === "GET") {
  if (isset($_GET["postId"])) {
    $commentController->getAllCommentByPostId($_GET['postId']);
  }
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
  if (isset($_GET["userId"]) && isset($_GET["commentId"])) {
    $commentController->commentLike($_GET["userId"], $_GET["commentId"]);
    exit();
  }

  // proceed to create a comment
  $user = json_decode(file_get_contents('php://input'));
  $commentController->postComment($user);

  exit();
}

// if ($_SERVER["REQUEST_METHOD"] === "PATCH") {

//   exit();
// }

// if ($_SERVER["REQUEST_METHOD"] === "DELETE") {

//   exit();
// }
