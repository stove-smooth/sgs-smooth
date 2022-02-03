import store from "@/store/index";
export default function Participant(name) {
  this.name = name;
  var container = document.createElement("div");
  container.className = isPresentMainParticipant()
    ? "participant"
    : "participant main";

  container.id = name;
  var span = document.createElement("span");
  var video = document.createElement("video");
  var rtcPeer;
  container.appendChild(video);
  container.appendChild(span);
  container.onclick = switchContainerClass;
  document.getElementById("participants").appendChild(container);
  span.appendChild(document.createTextNode(name));
  video.id = "video-" + name;
  video.autoplay = true;
  video.controls = false;
  var sdp;
  console.log("무의미", rtcPeer, sdp);
  this.getElement = function () {
    return container;
  };
  this.getVideoElement = function () {
    return video;
  };
  function switchContainerClass() {
    console.log("switchContainerClass", container.className);
    if (container.className === "participant") {
      var elements = Array.prototype.slice.call(
        document.getElementsByClassName("participant main")
      );
      elements.forEach(function (item) {
        item.className = "participant";
      });
      container.className = "participant main";
    } else {
      container.className = "participant";
    }
  }
  function isPresentMainParticipant() {
    return document.getElementsByClassName("participant main").length != 0;
  }
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

  Object.defineProperty(this, "rtcPeer", { writable: true });

  this.dispose = function () {
    console.log("Disposing participant " + this.name);
    this.rtcPeer.dispose();
    store.dispatch("voiceRoom/disposeParticipant", this.name);
  };
}
