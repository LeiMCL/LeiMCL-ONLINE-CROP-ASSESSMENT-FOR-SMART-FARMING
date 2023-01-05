<?php
class ConnectDB
{
  private $hostname = "localhost";
  private $user = "root";
  private $password = "";
  private $database = "db_crop_forum";

  public function connect()
  {
    try {
      //code...
      $conn = new mysqli($this->hostname, $this->user, $this->password, $this->database);
      return $conn;
    } catch (\Throwable $th) {
      //throw $th;
      echo "DB_ERROR_MESSAGE: " . $th->getMessage();
    }
  }
}
