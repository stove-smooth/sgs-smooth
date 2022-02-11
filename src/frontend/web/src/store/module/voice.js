import SockJS from "sockjs-client";
import kurentoUtils from "kurento-utils";
import Participant from "./js/participant.js";
import Vue from "vue";
const voice = {
  namespaced: true,
  state: {
    ws: null,
    wsOpen: false,
    myName: null,
    roomName: null,
    participants: null,
    //본인 장비
    mute: false, //음소거시 true
    deafen: false, //헤드셋 막을시 true
    video: false, //video 보임 여부
  },
  mutations: {
    WS_INIT(state, url) {
      state.ws = new SockJS(url, null, {
        transports: ["websocket", "xhr-streaming", "xhr-polling"],
      });
      return false;
    },
    setWsOpen(state, wsOpen) {
      console.log("setWsOpen", wsOpen);
      state.wsOpen = wsOpen;
    },
    setVoiceInfo(state, voiceInfo) {
      state.myName = voiceInfo.myName;
      state.roomName = voiceInfo.roomName;
    },
    addParticipant(state, { name, participant }) {
      if (state.participants === null) {
        state.participants = {};
      }
      //state.participants[name] = participant;
      Vue.set(state.participants, name, participant);
    },
    disposeParticipant(state, participantName) {
      Vue.delete(state.participants, participantName);
    },
    setMute(state) {
      console.log("setMute");
      state.mute = !state.mute;
    },
    setDeafen(state) {
      console.log("setDeafen");
      state.deafen = !state.deafen;
    },
    setVideo(state) {
      state.video = !state.video;
    },
  },
  actions: {
    wsInit(context, url) {
      console.log("init");
      context.commit("WS_INIT", url);
      context.state.ws.onopen = function () {
        console.log("connected");
        context.commit("setWsOpen", true);
      };
      context.state.ws.onmessage = function (message) {
        let parsedMessage = JSON.parse(message.data);
        console.log("Received message", message.data);
        context.dispatch("onServerMessage", parsedMessage);
      };
    },
    onServerMessage(context, message) {
      switch (message.id) {
        case "existingParticipants": {
          context.dispatch("onExistingParticipants", message);
          break;
        }
        case "newParticipantArrived": {
          context.dispatch("onNewParticipant", message);
          break;
        }
        case "participantLeft": {
          context.dispatch("onParticipantLeft", message);
          break;
        }
        case "receiveVideoAnswer": {
          context.dispatch("receiveVideoResponse", message);
          break;
        }
        case "iceCandidate": {
          context.state.participants[message.userId].rtcPeer.addIceCandidate(
            message.candidate,
            function (error) {
              if (error) {
                console.error("Error adding candidate: " + error);
                return;
              }
            }
          );
          break;
        }
        case "videoStateAnswer": {
          context.dispatch("videoStateTranslated", message);
          break;
        }
        default: {
          console.error("Unrecognized message" + message);
        }
      }
    },
    /**case */
    //case 1 - 내가 참가했을때
    onExistingParticipants(context, msg) {
      /* let constraints = {
        audio: true,
        video: {
          mandatory: {
            maxWidth: 320,
            maxFrameRate: 15,
            minFrameRate: 15,
          },
        },
      }; */
      console.log(
        context.state.myName + " registered in room " + context.state.roomName
      );
      let participant = new Participant(context.state.myName);

      var video = participant.getVideoElement();

      var options = {
        localVideo: video,
        //mediaConstraints: constraints,
        onicecandidate: participant.onIceCandidate.bind(participant),
      };

      participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerSendonly(
        options,
        function (error) {
          if (error) {
            return console.error(error);
          }
          /*  participant.audioEnabled = !context.state.mute;
          participant.videoEnabled = context.state.video; */
          this.audioEnabled = !context.state.mute;
          this.videoEnabled = context.state.video;
          this.generateOffer(participant.offerToReceiveVideo.bind(participant));
        }
      );
      console.log("내가 참가", participant);
      const myName = context.state.myName;
      context.commit("addParticipant", { name: myName, participant });
      msg.members.forEach(function (sender) {
        context.dispatch("receiveVideo", sender);
      });
    },
    //case -2 내가 속한 방에서 새 참가자가 들어왔을때
    onNewParticipant(context, request) {
      context.dispatch("receiveVideo", request.userId);
    },
    //case -3 참가자가 방에서 나갔을때
    onParticipantLeft(context, request) {
      console.log("Participant " + request.userId + " left");
      var participant = context.state.participants[request.userId];
      participant.dispose();
    },
    //case -4 SDP 정보 전송하여 응답 받음.
    receiveVideoResponse(context, result) {
      context.state.participants[result.userId].rtcPeer.processAnswer(
        result.sdpAnswer,
        function (error) {
          if (error) return console.error(error);
        }
      );
    },
    //case video state를 받는다.
    videoStateTranslated(context, result) {
      if (result.video == 1) {
        context.state.participants[result.userId].rtcPeer.videoEnabled = true;
      } else {
        context.state.participants[result.userId].rtcPeer.videoEnabled = false;
      }
    },
    // participant.dispose에서 오는 요청
    disposeParticipant(context, participantName) {
      context.commit("disposeParticipant", participantName);
    },
    //다른 참가자 video 받기
    receiveVideo(context, sender) {
      var participant = new Participant(sender);
      var video = participant.getVideoElement();
      //추가
      var options = {
        remoteVideo: video,
        onicecandidate: participant.onIceCandidate.bind(participant),
      };

      participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerRecvonly(
        options,
        function (error) {
          if (error) {
            return console.error(error);
          }
          this.generateOffer(participant.offerToReceiveVideo.bind(participant));
        }
      );
      console.log("다른 참가자 video를 받습니다.", participant);
      context.commit("addParticipant", { name: sender, participant });
    },
    setVoiceInfo(context, voiceInfo) {
      console.log("voice방 정보 저장");
      context.commit("setVoiceInfo", voiceInfo);
    },
    sendMessage(context, message) {
      let jsonMessage = JSON.stringify(message);
      context.state.ws.send(jsonMessage);
    },
    async leaveRoom(context) {
      for (var key in context.state.participants) {
        context.state.participants[key].dispose();
      }
      context.state.ws.close();
      await context.commit("setWsOpen", false);
    },
  },
};

export default voice;
