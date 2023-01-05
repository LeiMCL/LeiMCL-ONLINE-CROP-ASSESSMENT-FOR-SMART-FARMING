<?php
include '../../db_config/ConnectDB.php';
include './NotificationController.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header('Content-type: application/json');

$obj = new ConnectDB();
$conn = $obj->connect();
$notifController = new NotificationController($conn);

// send an error message if request method is not GET
if ($_SERVER["REQUEST_METHOD"] === "GET") {

  if (isset($_GET['userId'])) {
    $notifController->getAllNotifications($_GET['userId']);
  }
  exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
  exit();
}

// if ($_SERVER["REQUEST_METHOD"] === "PATCH") {

//   exit();
// }

// if ($_SERVER["REQUEST_METHOD"] === "DELETE") {

//   exit();
// }
