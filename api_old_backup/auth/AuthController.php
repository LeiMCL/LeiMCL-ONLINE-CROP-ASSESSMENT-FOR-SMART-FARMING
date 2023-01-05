<?php
class AuthController
{
  private $conn;

  function __construct($conn)
  {
    $this->conn = $conn;
  }

  public function getUserDataById($userId)
  {
    // proceed to get user data
    $getUserQry = $this->conn->prepare("SELECT user_id, name, username, email FROM tbl_user WHERE user_id = (?)");
    $getUserQry->bind_param("i", $userId);

    try {
      //code...
      $getUserQry->execute();
      $result = $getUserQry->get_result();
      $user = $result->fetch_assoc();

      echo json_encode((array(
        "user_id" => $user["user_id"],
        "name" => $user["name"],
        "username" => $user["username"],
        "email" => $user["email"],
      )));
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array("message" => $th->getMessage()));
      exit();
    }
  }

  public function loginUser($data)
  {
    $USERNAME = $data->username;
    $PASSWORD = $data->password;

    $loginUserQry = $this->conn->prepare("SELECT * FROM tbl_user WHERE username = (?) AND password = (?) ");
    $loginUserQry->bind_param("ss", $USERNAME, $PASSWORD);
    $loginUserQry->execute();

    $row = $loginUserQry->get_result()->fetch_assoc();

    if ($row === null) {
      echo json_encode(array('message' => 'Invalid Username or Password'));
      exit();
    }

    echo json_encode(array(
      'message' => 'success',
      'user_id' => $row['user_id']
    ));
  }

  public function createUser($data)
  {
    $NAME = $data->name;
    $USERNAME = $data->username;
    $EMAIL = $data->email;
    $PASSWORD = $data->password;

    $createUserQuery = $this->conn->prepare("INSERT INTO tbl_user (name, username, email, password) VALUES (?, ?, ?, ?)");
    $createUserQuery->bind_param("ssss", $NAME, $USERNAME, $EMAIL, $PASSWORD);
    try {
      //code...
      $createUserQuery->execute();
      $userId = $createUserQuery->insert_id;
    } catch (\Throwable $th) {
      //throw $th;
      echo json_encode(array('message' => $th->getMessage()));
      exit();
    }

    if ($createUserQuery->affected_rows === 0) {
      echo json_encode(array('message' => 'Something went wrong. Please try again later.'));
      exit();
    }

    echo json_encode(array(
      'message' => 'User Successfully Created!',
      'user_id' => $userId
    ));
  }
}
