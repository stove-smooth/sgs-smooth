import store from "@/store/index";
export default function Participant(name, videoStatus, audioStatus) {
  this.name = name;
  this.videoStatus = videoStatus;
  this.audioStatus = audioStatus;
  Object.defineProperty(this, "rtcPeer", { writable: true });

  var video = document.createElement("video");
  var rtcPeer;
  video.id = "video-" + name;
  video.classList.add("width-100");
  video.classList.add("height-100");
  video.autoplay = true;
  video.controls = false;
  video.playsInline = true;
  var sdp;
  console.log("무의미", rtcPeer, sdp);
  this.getVideoElement = function () {
    return video;
  };
  this.offerToReceiveVideo = function (error, offerSdp, wp) {
    console.log("무의미", wp);
    if (error) return console.error("sdp offer error");
    console.log("Invoking SDP offer callback function");
    var msg = { id: "receiveVideoFrom", userId: name, sdpOffer: offerSdp };
    store.dispatch("voice/sendMessage", msg);
  };

  this.onIceCandidate = function (candidate, wp) {
    console.log("무의미", wp);
    console.log("Local candidate" + JSON.stringify(candidate));
    var message = {
      id: "onIceCandidate",
      userId: name,
      candidate: candidate,
    };
    store.dispatch("voice/sendMessage", message);
  };

  this.dispose = function () {
    console.log("Disposing participant " + this.name);
    this.rtcPeer.dispose();
    store.dispatch("voice/disposeParticipant", this.name);
  };
}
