function selectProfile(code) {
  if (code == 0) {
    return "discord_blue";
  } else if (code == 1) {
    return "discord_green";
  } else if (code == 2) {
    return "discord_grey";
  } else {
    return "discord_red";
  }
}

export { selectProfile };
