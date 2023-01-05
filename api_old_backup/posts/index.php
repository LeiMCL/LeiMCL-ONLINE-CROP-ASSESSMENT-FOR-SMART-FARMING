<?php
include '../../db_config/ConnectDB.php';
include './PostController.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: *");
header('Content-type: application/json');

$obj = new ConnectDB();
$conn = $obj->connect();
$postController = new PostController($conn);

// send an error message if request method is not GET
if ($_SERVER["REQUEST_METHOD"] === "GET") {
  // echo json_encode(array('ERROR_MESSAGE' => 'REQUEST METHOD ERROR'));

  if (isset($_GET['postId'])) {
    $postController->getPostByPostId($_GET['postId']);
    exit();
  }

  // Get post of user by post ID
  if (isset($_GET["userId"])) {
    $postController->getAllPostByUserId($_GET['userId']);
  } else {
    // Get all Posts
    $postController->getAllPosts();
  }

  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
  if (isset($_GET["userId"]) && isset($_GET["postId"])) {
    $postController->postLike($_GET["userId"], $_GET["postId"]);
    exit();
  }

  // proceed to create a post
  $user = json_decode(file_get_contents('php://input'));
  $postController->createPost($user);
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "PATCH") {
  // proceed to edit a post
  $user = json_decode(file_get_contents('php://input'));
  $postController->editPost($user);
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "DELETE") {
  // proceed to edit a post
  // $user = json_decode(file_get_contents('php://input'));
  $postController->deletePost($_GET['post_id']);
  exit();
}
