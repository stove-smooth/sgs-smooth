function saveAccessAuthToCookie(value) {
  document.cookie = `accessauth=${value}`;
}

function saveRefreshAuthToCookie(value) {
  document.cookie = `refreshauth=${value}`;
}

function saveUserEmailToCookie(value) {
  document.cookie = `useremail=${value}`;
}

function saveUserNickNameToCookie(value) {
  document.cookie = `usernickname=${value}`;
}

function saveUserCodeToCookie(value) {
  document.cookie = `usercode=${value}`;
}
/* function saveRoleToCookie(value) {
  document.cookie = `role=${value}`;
} */

function getAccessAuthToCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)accessauth\s*=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

function getRefreshAuthToCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)refreshauth\s*=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

function getUserEmailToCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)useremail\s*=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

function getUserNickNameToCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)usernickname\s*=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

function getUserCodeToCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)usercode\s*=\s*([^;]*).*$)|^.*$/,
    "$1"
  );
}

/* function getRoleFromCookie() {
  return document.cookie.replace(
    /(?:(?:^|.*;\s*)role\s*=\s*([^;]*).*$)|^.*$/,
    '$1',
  );
} */

/* function deleteCookie(value) {
  document.cookie = `${value}=; expires=Thu, 01 Jan 1970 00:00:01 GMT;`;
} */

export {
  saveAccessAuthToCookie,
  saveRefreshAuthToCookie,
  saveUserEmailToCookie,
  saveUserNickNameToCookie,
  saveUserCodeToCookie,
  getAccessAuthToCookie,
  getRefreshAuthToCookie,
  getUserEmailToCookie,
  getUserNickNameToCookie,
  getUserCodeToCookie,
};
