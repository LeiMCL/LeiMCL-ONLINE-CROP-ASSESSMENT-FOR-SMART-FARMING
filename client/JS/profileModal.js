// Get the modal
var modal = document.getElementById("myModal");
const editPostModal = document.getElementById("editPostModal");
const deletePostModal = document.getElementById("deletePostModal");

// Get the button that opens the modal
// var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];
var span2 = document.getElementsByClassName("closeEditModal")[0];
var span3 = document.getElementsByClassName("closeDeleteModal")[0];

// When the user clicks the button, open the modal
// btn.onclick = function () {
//   modal.style.display = "block";
// };

// When the user clicks on <span> (x), close the modal
span.onclick = function () {
  modal.style.display = "none";
};

span2.onclick = function () {
  editPostModal.style.display = "none";
};

span3.onclick = function () {
  deletePostModal.style.display = "none";
  localStorage.removeItem("post_to_delete_id");
};

// When the user clicks anywhere outside of the modal, close it
window.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
  if (event.target == editPostModal) {
    editPostModal.style.display = "none";
  }
};
