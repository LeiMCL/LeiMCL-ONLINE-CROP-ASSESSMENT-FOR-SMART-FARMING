// This script is for the communicating to the Server(Backend)
const API_URL = "http://localhost/crop_forum/api";

// It's important to include index.php when sending a request with data.

// require to send an JSON Object containing the ff keys and values:
// Object = {
//   name,
//   username,
//   email,
//   password,
//   mode = "register"
// }
// createUser will return a message and user_id of the new user
const createUser = async (userData) => {
  // axios.post(url, data_to_send)
  const response = await axios.post(API_URL + "/auth/index.php", userData);
  // return a data to the request
  return response.data;
};

// loginUser will required to send JSON OBject containing:
// if successfully login will return a message and user_id of the user
// Object = {
//   username,
//   password,
//   mode = "login"
// }
const loginUser = async (userData) => {
  const response = await axios.post(API_URL + "/auth/index.php", userData);
  console.log(response);
  // return a data to the request
  return response.data;
};

// will return the data of the user
const getUserDataById = async (userId) => {
  // axios.get(url, data_to_send[optional])
  const response = await axios.get(
    API_URL + "/auth/index.php?userId=" + userId
  );
  return response;
};

// Create a post
// need to send a JSON Object
// Object = {
//   user_id: value,
//   content: value,
// }
const createPost = async (postData) => {
  const response = await axios.post(API_URL + "/posts/index.php", postData);
  return response.data;
};

// Edit a Post
const updatePost = async (postData) => {
  const response = await axios.patch(API_URL + "/posts/index.php", postData);
  return response.data;
};

const deletePost = async (postId) => {
  // const id = {
  //   post_id: postId,
  // };
  const response = await axios.delete(API_URL + "/posts/index.php", {
    params: {
      post_id: postId,
    },
  });
  return response.data;
};

// Like checker for current user
// need to sen JSON Object
// Object = { user_id, post_id}
const checkLikePost = async (data) => {
  const response = await axios.post(API_URL + "/likes/index.php", data);
  return response.data;
};

// Like checker for current user
// need to sen JSON Object
// Object = { user_id, post_id}
const checkLikeComment = async (data) => {
  const response = await axios.post(API_URL + "/likes/index.php", data);
  return response.data;
};

// Like a post
// need to put a param query by userId and postId
const likePost = async (postData) => {
  const response = await axios.post(
    API_URL +
      "/posts/index.php?userId=" +
      postData.userId +
      "&postId=" +
      postData.postId
  );
  return response;
};

// Like a comment
// need to put a param query by userId and commentId
const likeComment = async (commentData) => {
  const response = await axios.post(
    API_URL +
      "/comments/index.php?userId=" +
      commentData.userId +
      "&commentId=" +
      commentData.commentId
  );
  return response;
};

// Get all the posts of all the user
const getAllUserPosts = async () => {
  const response = await axios.get(API_URL + "/posts/index.php");
  return response;
};

// Get all the posts of the user logged in
const getAllUserPostByUserId = async (userId) => {
  const response = await axios.get(
    API_URL + "/posts/index.php?userId=" + userId
  );
  return response.data;
};

// Get single post by post id
const getPostByPostId = async (postId) => {
  const response = await axios.get(
    API_URL + "/posts/index.php?postId=" + postId
  );
  return response.data;
};

// Get comments by post using post id
const getCommentByPostId = async (post_id) => {
  const response = await axios.get(
    API_URL + "/comments/index.php?postId=" + post_id
  );
  return response.data;
};

// Create comment into the post using post id
const createComment = async (commentData) => {
  const response = await axios.post(
    API_URL + "/comments/index.php",
    commentData
  );
  console.log(response.data);
  return response.data;
};

// Get All Notifications of Current User
const getNotification = async (user_id) => {
  const response = await axios.get(API_URL + "/notifications/index.php", {
    params: {
      userId: user_id,
    },
  });

  return response.data;
};
