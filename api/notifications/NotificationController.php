<?php
class NotificationController
{
  private $conn;

  function __construct($conn)
  {
    $this->conn = $conn;
  }

  function getAllNotifications($userId)
  {
    $getNotifQry = $this->conn->prepare("SELECT * FROM notifications WHERE user_id = (?) ORDER BY created_at DESC");
    $getNotifQry->bind_param("i", $userId);

    $notifArray = array();
    try {
      //code...
      $getNotifQry->execute();
      $result = $getNotifQry->get_result();
      while ($notif = $result->fetch_assoc()) {
        array_push(
          $notifArray,
          array(
            'notification_id' => $notif['notification_id'],
            'user_id' => $notif['user_id'],
            'post_id' => $notif['post_id'],
            'content' => $notif['content'],
            'created_at' => $notif['created_at']
          )
        );
      }
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if (count($notifArray) === 0) {
      echo json_encode(array("message" => "No current notification"));
      exit();
    }

    echo json_encode($notifArray);
  }
}
