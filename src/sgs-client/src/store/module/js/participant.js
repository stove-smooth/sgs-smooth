import store from "@/store/index";
export default function Participant(name) {
  this.name = name;

  Object.defineProperty(this, "rtcPeer", { writable: true });

  var video = document.createElement("video");
  var rtcPeer;

  video.id = "video-" + name;
  video.autoplay = true;
  video.controls = false;
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
    store.dispatch("voiceRoom/sendMessage", msg);
  };

  this.onIceCandidate = function (candidate, wp) {
    console.log("무의미", wp);
    console.log("Local candidate" + JSON.stringify(candidate));
    var message = {
      id: "onIceCandidate",
      userId: name,
      candidate: candidate,
    };
    store.dispatch("voiceRoom/sendMessage", message);
  };

  this.dispose = function () {
    console.log("Disposing participant " + this.name);
    this.rtcPeer.dispose();
    store.dispatch("voiceRoom/disposeParticipant", this.name);
  };
}
