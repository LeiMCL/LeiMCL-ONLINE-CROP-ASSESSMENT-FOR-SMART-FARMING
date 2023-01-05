window.onload = () => {
  const navSignInText = document.getElementById("navSignIn");

  // if user doesn't exists
  if (!localStorage.getItem("userId")) {
    navSignInText.textContent = "SIGN IN";
    return;
  }

  // if user exist
  navSignInText.textContent = "FORUM";

  // when click forum / sign in link
  // redirect to forumpage if user exist
  // if not then to register.html
  navSignInText.addEventListener("click", (e) => {
    e.preventDefault();
    if (!localStorage.getItem("userId")) {
      location.href = "register.html";
      return;
    }

    location.href = "forumpage.html";
  });

  const btnSignOut = document.getElementById("btnSignOut");
  btnSignOut.addEventListener("click", (e) => {
    localStorage.clear();
    location.href = "register.html";
  });
};

// if user tried to access forumpage, profilee, notif without access
// redirect to home
let filename = location.pathname;

if (
  filename.includes("/forumpage") ||
  filename.includes("/notif.html") ||
  filename.includes("/profilee.html")
) {
  // if user doesn't exists
  if (!localStorage.getItem("userId")) {
    location.href = "index.html";
  }
}
