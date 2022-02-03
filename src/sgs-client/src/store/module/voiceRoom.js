import SockJS from "sockjs-client";
import kurentoUtils from "kurento-utils";
import Participant from "./js/participant.js";
import Vue from "vue";
const voiceRoom = {
  namespaced: true,
  state: {
    ws: null,
    myName: null,
    roomName: null,
    participants: null,
  },
  mutations: {
    WS_INIT(state, url) {
      state.ws = new SockJS(url, null, {
        transports: ["websocket", "xhr-streaming", "xhr-polling"],
      });
      return false;
    },
    setVoiceInfo(state, meetingInfo) {
      state.myName = meetingInfo.myName;
      state.roomName = meetingInfo.roomName;
    },
    addParticipant(state, { name, participant }) {
      /**베껴온거라 뭔지 잘 모름. */
      if (state.participants === null) {
        state.participants = {};
      }
      // 객체 변경 감지를 위한 추가법
      Vue.set(state.participants, name, participant);
      //state.participants[name] = participant
      // 디버깅
      /* console.log('participant added', state.participants); */
      // 임시코드 종료
    },
    disposeParticipant(state, participantName) {
      Vue.delete(state.participants, participantName);
    },
  },
  actions: {
    wsInit(context, url) {
      context.commit("WS_INIT", url);
      context.state.ws.onopen = function () {
        console.log("connected");
      };
      context.state.ws.onmessage = function (message) {
        let parsedMessage = JSON.parse(message.data);
        // console.info('Received message: ' + message.data)
        /* context.commit('WS_ONMESSAGE', parsedMessage); */
        console.log(parsedMessage);
        context.dispatch("onServerMessage", parsedMessage);
        return false;
      };
      return false;
    },
    onServerMessage(context, message) {
      console.log("message옴", context, message);
      switch (message.id) {
        case "existingParticipants": {
          console.log("왔다링.");
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
        default: {
          console.error("Unrecognized message" + message);
        }
      }
    },
    /**case */
    //case 1 - 내가 참가했을때
    onExistingParticipants(context, msg) {
      console.log("왔음", msg);
      let constraints = {
        audio: true,
        video: {
          mandatory: {
            maxWidth: 320,
            maxFrameRate: 15,
            minFrameRate: 15,
          },
        },
      };
      console.log(
        context.state.myName + " registered in room " + context.state.roomName
      );
      let participant = new Participant(context.state.myName);
      console.log("participant", participant);

      var video = participant.getVideoElement();

      var options = {
        localVideo: video,
        mediaConstraints: constraints,
        onicecandidate: participant.onIceCandidate.bind(participant),
      };
      console.log(
        "options",
        options.localVideo,
        options.mediaConstraints,
        options.onicecandidate
      );
      console.log("msg", msg);
      participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerSendonly(
        options,
        function (error) {
          if (error) {
            return console.error(error);
          }
          this.generateOffer(participant.offerToReceiveVideo.bind(participant));
        }
      );
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
    //case -3
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
    // participant.dispose에서 오는 요청
    disposeParticipant(context, participantName) {
      context.commit("disposeParticipant", participantName);
    },
    //다른 참가자 video 받기
    receiveVideo(context, sender) {
      var participant = new Participant(sender);
      var video = participant.getVideoElement();

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
      context.commit("addParticipant", { name: sender, participant });
    },
    setVoiceInfo(context, meetingInfo) {
      context.commit("setVoiceInfo", meetingInfo);
    },
    sendMessage(context, message) {
      let jsonMessage = JSON.stringify(message);
      console.log("sendMessage", message);
      context.state.ws.send(jsonMessage);
    },
    leaveRoom(context) {
      for (var key in context.state.participants) {
        context.state.participants[key].dispose();
      }
      context.state.ws.close();
    },
  },
};

export default voiceRoom;
