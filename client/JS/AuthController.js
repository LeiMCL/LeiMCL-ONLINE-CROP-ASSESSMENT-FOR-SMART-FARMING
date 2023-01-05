// Handle the Registration Form Submit
const registerForm = document.querySelector("#register");
registerForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const name = registerForm.elements["r_name"].value;
  const email = registerForm.elements["r_email"].value;
  const username = registerForm.elements["r_username"].value;
  const password = registerForm.elements["r_password"].value;
  const confirm_password = registerForm.elements["r_confirm_password"].value;

  // check if password and confirm password match
  if (password !== confirm_password) {
    alert("Password not match");
    return;
  }

  // create the Object
  const userData = {
    name,
    email,
    username,
    password,
    mode: "register",
  };
  const { message, user_id } = await createUser(userData);
  alert(message);
  location.href = "register.html";
});

// Handle the Login Form Submit
const loginForm = document.querySelector("#login");
loginForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const username = loginForm.elements["l_username"].value;
  const password = loginForm.elements["l_password"].value;

  // create the Object
  const userData = {
    username,
    password,
    mode: "login",
  };

  const { message, user_id } = await loginUser(userData);

  // check if message returns a success
  if (message === "success") {
    // store the user ID to the local storage for checking if there's a user logged in
    localStorage.setItem("userId", user_id);
    location.href = "forumpage.html";
  }
});
