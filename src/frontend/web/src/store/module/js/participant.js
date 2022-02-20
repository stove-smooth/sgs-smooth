import store from "@/store/index";
export default function Participant(name, videoStatus, audioStatus) {
  this.name = name;
  this.videoStatus = videoStatus;
  this.audioStatus = audioStatus;
  Object.defineProperty(this, "rtcPeer", { writable: true });

  var video = document.createElement("video");

  video.id = "video-" + name;
  video.classList.add("width-100");
  video.classList.add("height-100");
  video.autoplay = true;
  video.controls = false;
  video.playsInline = true;

  this.getVideoElement = function () {
    return video;
  };
  this.offerToReceiveVideo = function (error, offerSdp) {
    if (error) return console.error("sdp offer error");
    var msg = { id: "receiveVideoFrom", userId: name, sdpOffer: offerSdp };
    store.dispatch("voice/sendMessage", msg);
  };

  this.onIceCandidate = function (candidate) {
    var message = {
      id: "onIceCandidate",
      userId: name,
      candidate: candidate,
    };
    store.dispatch("voice/sendMessage", message);
  };

  this.dispose = function () {
    this.rtcPeer.dispose();
    store.dispatch("voice/disposeParticipant", this.name);
  };
}
