<?php
include '../../db_config/ConnectDB.php';
include './LikeController.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header('Content-type: application/json');

$obj = new ConnectDB();
$conn = $obj->connect();
$likeController = new LikeController($conn);

// send an error message if request method is not GET
if ($_SERVER["REQUEST_METHOD"] === "GET") {
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
  // if (isset($_GET["userId"]) && isset($_GET["commentId"])) {
  //   $commentController->commentLike($_GET["userId"], $_GET["commentId"]);
  //   exit();
  // }

  $user = json_decode(file_get_contents('php://input'));

  if ($user->mode === "comment") {
    $likeController->isCommentLike($user);
    exit();
  }

  if ($user->mode === "post") {
    $likeController->isPostLike($user);
    exit();
  }

  exit();
}

// if ($_SERVER["REQUEST_METHOD"] === "PATCH") {

//   exit();
// }

// if ($_SERVER["REQUEST_METHOD"] === "DELETE") {

//   exit();
// }
