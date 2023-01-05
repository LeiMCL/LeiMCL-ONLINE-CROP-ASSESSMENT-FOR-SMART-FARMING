// $(async function () {
//   // modal.style.display = "block";

// });

$(document).ready(async function () {
  await getUser(localStorage.getItem("userId"));
  await getAllPosts();
  // if(location.hre)
  // $("#post12")[0].scrollIntoView();
  if (location.href.includes("#")) {
    const post = location.href.split("#")[1];
    $("#" + post)[0].scrollIntoView();
  }
});

// For getting and displaying user data
const getUser = async (userId) => {
  const { data, message } = await getUserDataById(userId);
  if (!data) {
    return message;
  }

  const user_name = document.querySelector("#logged_user");

  user_name.innerHTML = data.name;
  return data;
};

// Getting All Post
const getAllPosts = async () => {
  const userId = localStorage.getItem("userId");

  const data = await getAllUserPostByUserId(userId);
  const post_container = document.querySelector("#post-container");

  if (data?.message) {
    const h4 = document.createElement("h4");
    h4.innerHTML = data.message;
    post_container.appendChild(h4);
    return;
  }

  // if notification clicked
  let postNotif = -1;
  if (location.href.includes("#")) {
    const post = location.href.split("#")[1];
    postNotif = parseInt(post.match(/\d+/gi).join(""));
  }

  data.map(async (post) => {
    // let single_post = $(
    //   `<div class='forumnews'>
    //     <div class='user-profile'>
    //       <img src='./images/users.png'>
    //       <p>${post.name}</p>
    //       <p class='post-date'>${post.created_at}</p>
    //     </div>
    //     <p class='post-text'>${post.content}</p>
    //     <div class='post-row'>
    //       <div class='activity-icons'>
    //         <button type='button' id='${post.post_id}' name='btnLikePost'
    //         class=''
    //         >
    //           <img src='./images/like-icons.png'>
    //           ${post.like_count}
    //         </button>
    //         <button type='button' id='${post.post_id}' name='btnPostComment'>
    //           <img src='./images/comment-icon.png'>
    //           ${post.comment_count}
    //         </button>
    //         <button type='button' id='${post.post_id}' name='btnEditPost'>
    // 					<img src='./images/edit-icon.png'>
    // 				</button>
    // 				<button type='button' id='${post.post_id}' name='btnDeletePost'>
    // 					<img src='./images/delete-icon.png'>
    // 				</button>
    //       </div>
    //     </div>
    //   </div>
    //   `
    // );
    let single_post = $(
      `<div class='forumnews ${
        postNotif === post.post_id ? "post-notif" : ""
      }' id='post${post.post_id}'>
        <div class='user-profile'>
          <img src='./images/users.png'>
          <p>${post.name}</p>
          <p class='post-date'>${post.created_at}</p>
        </div>
        <p class='post-text'>${post.content}</p>
        <div class='post-row'>
          <div class='activity-icons'>
            <button type='button' id='${post.post_id}' name='btnLikePost'
            class=''
            >
              <span>${post.like_count} |</span> Like

            </button>
            <button type='button' id='${post.post_id}' name='btnPostComment'>
              Comment
            </button>
            <button type='button' id='${post.post_id}' name='btnEditPost'>
							Edit
						</button>
						<button type='button' id='${post.post_id}' name='btnDeletePost'>
							Delete
						</button>
          </div>
        </div>
      </div>
      `
    );
    $(post_container).append(single_post);
  });

  // check current user like posts
  data.map(async (post) => {
    var { isLike } = await checkLikePost({
      user_id: localStorage.getItem("userId"),
      post_id: post.post_id,
      mode: "post",
    });
    if (isLike === "true") {
      $(`button[id='${post.post_id}'][name='btnLikePost']`).addClass(
        "liked-button"
      );
    } else {
      $(`button[id='${post.post_id}'][name='btnLikePost']`).addClass(
        "not-liked-button"
      );
    }
  });

  $("button[name='btnLikePost']").on("click", async function (e) {
    e.preventDefault();
    const user_id = localStorage.getItem("userId");
    const post_id = this.id;
    await likePost({
      userId: user_id,
      postId: post_id,
    });
    var like_value = parseInt(
      $(`button[name='btnLikePost'][id=${post_id}]`).text()
    );
    var { isLike } = await checkLikePost({
      user_id: user_id,
      post_id: post_id,
      mode: "post",
    });
    if (isLike === "true") {
      $(`button[name='btnLikePost'][id=${post_id}]`).toggleClass(
        "liked-button"
      );
      $(`button[name='btnLikePost'][id=${post_id}]`).toggleClass(
        "not-liked-button"
      );
      // isLike = "true";
      $(`button[name='btnLikePost'][id=${post_id}]`).html(
        `<span>${like_value + 1} |</span> Like`
        // "<img src='./images/like-icons.png'>" + (like_value + 1)
      );
    } else {
      $(`button[name='btnLikePost'][id=${post_id}]`).toggleClass(
        "liked-button"
      );
      $(`button[name='btnLikePost'][id=${post_id}]`).toggleClass(
        "not-liked-button"
      );
      // isLike = "false";
      $(`button[name='btnLikePost'][id=${post_id}]`).html(
        `<span>${like_value - 1} |</span> Like`
        // "<img src='./images/like-icons.png'>" + (like_value - 1)
      );
    }
  });

  $("button[name='btnPostComment']").on("click", async function (e) {
    e.preventDefault();
    resetComment();
    // localStorage.setItem("postId", post_id);
    modal.style.display = "block";
    const post_id = this.id;
    await getCommentByPost(post_id);
  });

  $("button[name='btnEditPost']").on("click", async function (e) {
    // e.preventDefault();
    editPostModal.style.display = "block";
    const post_id = this.id;
    await editPost(post_id);
  });

  $("button[name='btnDeletePost']").on("click", async function (e) {
    // e.preventDefault();
    deletePostModal.style.display = "block";
    localStorage.setItem("post_to_delete_id", this.id);
  });

  $("button[name='btn-yes'").on("click", async (e) => {
    e.preventDefault();
    const post_id = localStorage.getItem("post_to_delete_id");

    const { message } = await deletePost(post_id);

    alert(message);
    location.href = "profilee.html";
  });

  $("button[name='btn-no'").on("click", () => {
    deletePostModal.style.display = "none";
    localStorage.removeItem("post_to_delete_id");
  });

  console.log(data);
};

// reset the comment section
const resetComment = () => {
  const comments = document.getElementsByClassName("single-comment");
  for (var i = comments.length - 1; i >= 0; i--) {
    var childNode = comments[i];
    childNode.parentNode.removeChild(childNode);
  }
};

// Get all the Comment per Post
const getCommentByPost = async (post_id) => {
  var data = await getCommentByPostId(post_id);

  // needed for inserting new comment
  localStorage.setItem("postId", post_id);

  const comment_footer = document.getElementById("comment-footer");

  if (data?.message) {
    let message = $(`
      <div class='single-comment'>
        <h2 style='text-align: center;'>
          ${data?.message}
        </h2>
      </div>
    `);
    $(message).insertBefore(comment_footer);
    return;
  }

  data.map(async (comment) => {
    // let single_comment = $(`
    //   <div class='single-comment'>
    //     <h2 style='text-transform: capitalize;'>${comment.name}</h2>
    //     <p>${comment.content}</p>
    //     <button type='button' id='${comment.comment_id}' name='btnLikeComment'>
    //       <img src="./images/like-icons.png">${comment.like_count}
    //     </button>
    //   </div>
    // `);

    let single_comment = $(`
      <div class='single-comment'>
        <h2 style='text-transform: capitalize;'>${comment.name}</h2>
        <p>${comment.content}</p>
        <button type='button' id='${comment.comment_id}' name='btnLikeComment'>
          <span>${comment.like_count} |</span> Like
        </button>
      </div>
    `);

    $(single_comment).insertBefore(comment_footer);
  });

  // check current user like the comment
  data.map(async (comment) => {
    var { isLike } = await checkLikeComment({
      user_id: localStorage.getItem("userId"),
      comment_id: comment.comment_id,
      mode: "comment",
    });
    // alert(isLike);
    if (isLike === "true") {
      $(`button[id='${comment.comment_id}'][name='btnLikeComment']`).addClass(
        "liked-button"
      );
    } else {
      $(`button[id='${comment.comment_id}'][name='btnLikeComment']`).addClass(
        "not-liked-button"
      );
    }
  });

  $("button[name='btnLikeComment']").on("click", async function (e) {
    e.preventDefault();
    const user_id = localStorage.getItem("userId");
    const comment_id = this.id;
    $(`button[name='btnLikeComment'][id=${comment_id}]`).toggleClass(
      "liked-button"
    );
    $(`button[name='btnLikeComment'][id=${comment_id}]`).toggleClass(
      "not-liked-button"
    );
    await likeComment({
      userId: user_id,
      commentId: comment_id,
    });
    var like_value = parseInt(
      $(`button[name='btnLikeComment'][id=${comment_id}]`).text()
    );
    var { isLike } = await checkLikeComment({
      user_id: user_id,
      comment_id: comment_id,
      mode: "comment",
    });
    if (isLike === "true") {
      $(`button[name='btnLikeComment'][id=${comment_id}]`).html(
        `<span>${like_value + 1} |</span> Like`
        // "<img src='./images/like-icons.png'>" + (like_value + 1)
      );
    } else {
      $(`button[name='btnLikeComment'][id=${comment_id}]`).html(
        `<span>${like_value - 1} |</span> Like`
        // "<img src='./images/like-icons.png'>" + (like_value - 1)
      );
    }
  });

  console.log(data);
};

// Make a Comment
const btn_comment = document.getElementById("btn-comment-send");
btn_comment.addEventListener("click", async (e) => {
  const comment_content = document.getElementById("input-comment");
  const post_id = localStorage.getItem("postId");
  const user_id = localStorage.getItem("userId");

  const { name } = await getUser(user_id);

  if (comment_content.value === "") {
    alert("Comment cannot be empty");
    localStorage.removeItem("postId");
    return;
  }

  const commentData = {
    post_id,
    user_id,
    content: comment_content.value,
  };

  const { message, comment_id } = await createComment(commentData);

  // let single_comment = $(`
  //     <div class='single-comment'>
  //       <h2 style='text-transform: capitalize;'>${name}</h2>
  //       <p>${comment_content.value}</p>
  //       <button type='button' id='${comment_id}' name='btnLikeComment'>
  //         <img src="./images/like-icons.png">0
  //       </button>
  //     </div>
  // `);

  let single_comment = $(`
      <div class='single-comment'>
        <h2 style='text-transform: capitalize;'>${name}</h2>
        <p>${comment_content.value}</p>
        <button type='button' id='${comment_id}' name='btnLikeComment'>
          <span>0 |</span> Like
        </button>
      </div>
    `);

  $(single_comment).insertBefore("#comment-footer");
  comment_content.value = "";
  alert(message);
  localStorage.removeItem("postId");
});

// Create a post
const btn_post = document.querySelector("#btn-post");
btn_post.addEventListener("click", async (e) => {
  e.preventDefault();

  const post_content = document.querySelector("#input-post-content");

  if (post_content.value === "") {
    alert("Post cannot be empty!");
    return;
  }

  const userId = localStorage.getItem("userId");

  const { message } = await createPost({
    user_id: userId,
    content: post_content.value,
  });

  alert(message);

  location.href = "profilee.html";
});

// Edit a post
const editPost = async (post_id) => {
  const editPostInput = document.getElementById("input-edit-post-content");
  $("button[name='btn-save-edit']").attr("id", post_id);

  const { content } = await getPostByPostId(post_id);
  editPostInput.value = content;
};

// When Edit Post Button Save
$("button[name='btn-save-edit']").on("click", async (e) => {
  const editPostInput = document.getElementById("input-edit-post-content");

  if (editPostInput.value === "") {
    alert("Post content cannot be Empty!");
    return;
  }

  var post_id = e.target.id;
  if ($(e.target).prop("tagName") === "IMG") {
    post_id = $(e.target).parent().attr("id");
  }

  const postData = {
    post_id: post_id,
    content: editPostInput.value,
  };

  const { message } = await updatePost(postData);

  alert(message);
  location.href = "profilee.html";
});
