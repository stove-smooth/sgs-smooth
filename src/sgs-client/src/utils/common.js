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

function processFile(image) {
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.readAsDataURL(image);
    reader.onload = () => {
      let tempImage = new Image();
      tempImage.src = reader.result;
      resolve(tempImage);
    };
  });
}
function processFile2(tempImage) {
  let dataURI;
  let thumbnail;
  return new Promise((resolve) => {
    tempImage.onload = function () {
      let canvas = document.createElement("canvas");
      let canvasContext = canvas.getContext("2d");

      canvas.width = 100;
      canvas.height = 100;

      canvasContext.drawImage(this, 0, 0, 100, 100);

      dataURI = canvas.toDataURL("image/jpeg");
      console.log(dataURI);
      thumbnail = dataURI;
      resolve(thumbnail);
    };
  });
}
async function converToThumbnail(image) {
  const result = await processFile(image);
  const thumbnail = await processFile2(result);
  return thumbnail;
}
export { selectProfile, converToThumbnail };
