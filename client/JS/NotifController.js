const getNotificationByUserId = async (user_id) => {
  const data = await getNotification(user_id);

  const notif_container = document.querySelector("#forum-container");

  if (data?.message) {
    let notif_message = $(`
      <h2 style='text-align: center; margin-top: 2rem; color: #f0f0f0;'>
        ${data.message}
      </h2>
    `);
    $(notif_container).append(notif_message);
    return;
  }
  console.log(data);
  data.map((notif) => {
    console.log(notif);
    let single_notif = $(`
      <a href='profilee.html#post${
        notif.post_id
      }' class='notif-container' id='${notif.notification_id}'>
        <img src='
        ${
          notif.content.includes("liked")
            ? "./images/like-icons.png"
            : "./images/commentss.png"
        }
        '/>
        <p style='text-transform: capitalize'>${notif.content}</p>
      </a>
    `);

    $(notif_container).append(single_notif);
  });
};

getNotificationByUserId(localStorage.getItem("userId"));
