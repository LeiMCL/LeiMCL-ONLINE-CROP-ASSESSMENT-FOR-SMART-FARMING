<?php
include '../../db_config/ConnectDB.php';
include './AuthController.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header('Content-type: application/json');

$obj = new ConnectDB();
$conn = $obj->connect();
$authController = new AuthController($conn);

// send an error message if request method is not GET
if ($_SERVER["REQUEST_METHOD"] === "GET") {
  if (!isset($_GET['userId'])) {
    echo json_encode(array("message" => "User ID cannot be empty."));
    exit();
  }
  $authController->getUserDataById($_GET['userId']);
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
  // proceed to create a user
  $user = json_decode(file_get_contents('php://input'));

  $MODE = $user->mode;

  if ($MODE === "login") {
    $authController->loginUser($user);
    exit();
  }

  if ($MODE === "register") {
    $authController->createUser($user);
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
