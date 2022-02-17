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
    //현재 음성 연결 위치
    currentVoiceRoom: null,
    currentVoiceRoomType: null,
  },
  mutations: {
    setWsInit(state, url) {
      state.ws = new SockJS(url, null, {
        transports: ["websocket", "xhr-streaming", "xhr-polling"],
      });
      //console.log("wswsws", JSON.stringify(state.ws));
      //sessionStorage.setItem("webRtc", JSON.stringify(state.ws));
      return false;
    },
    setWsOpen(state, wsOpen) {
      //console.log("setWsOpen", wsOpen);
      sessionStorage.setItem("webRtc", wsOpen);
      state.wsOpen = wsOpen;
    },
    setVoiceInfo(state, voiceInfo) {
      state.myName = voiceInfo.myName;
      state.roomName = voiceInfo.roomName;
    },
    addParticipant(state, { name, participant }) {
      //console.log("나는 누구든 참여자가 늘어납니다.", name, participant);
      if (state.participants === null) {
        state.participants = {};
      }
      console.log("addParticipant", name, participant);
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
    setCurrentVoiceRoom(state, currentVoiceRoom) {
      state.currentVoiceRoom = currentVoiceRoom;
    },
    setCurrentVoiceRoomType(state, currentVoiceRoomType) {
      state.currentVoiceRoomType = currentVoiceRoomType;
    },
  },
  actions: {
    wsInit(context, info) {
      console.log("init", info);
      context.commit("setWsInit", info.url);
      context.commit("setCurrentVoiceRoomType", info.type);
      context.state.ws.onopen = function () {
        console.log("connected");
        context.commit("setWsOpen", true);
      };
      context.state.ws.onmessage = function (message) {
        let parsedMessage = JSON.parse(message.data);
        //alert("Received message" + message.data);
        console.log("온 메시지ㅣㅣㅣㅣㅣ", message.data);
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
    //case -1 내가 참가했을때
    onExistingParticipants(context, msg) {
      console.log(
        context.state.myName +
          " registered in room " +
          context.state.roomName +
          "video" +
          context.state.video +
          "mute" +
          context.state.mute
      );
      let participant = new Participant(
        context.state.myName,
        context.state.video,
        context.state.mute
      );

      var video = participant.getVideoElement();

      var options = {
        localVideo: video,
        onicecandidate: participant.onIceCandidate.bind(participant),
      };

      participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerSendonly(
        options,
        function (error) {
          if (error) {
            return console.error(error);
          }
          this.audioEnabled = !context.state.mute;
          this.videoEnabled = context.state.video;
          this.generateOffer(participant.offerToReceiveVideo.bind(participant));
        }
      );
      let members = JSON.stringify(msg);
      console.log(
        "내가 참가" + JSON.stringify(participant) + "*******************" + msg,
        members
      );
      const myName = context.state.myName;
      context.commit("addParticipant", { name: myName, participant });

      msg.members.forEach(function (sender) {
        context.dispatch("receiveVideo", sender);
      });
    },
    //case -2 내가 속한 방에서 새 참가자가 들어왔을때
    onNewParticipant(context, request) {
      console.log("newparticipant왔어용ㅇ@@@@@@@@@@@", request);
      context.dispatch("receiveVideo", request.member);
    },
    //case -3 참가자가 방에서 나갔을때
    onParticipantLeft(context, request) {
      console.log("Participant " + request.userId + " left");
      var participant = context.state.participants[request.userId];
      participant.dispose();
    },
    //case -4 SDP 정보 전송하여 응답 받음.
    receiveVideoResponse(context, result) {
      console.log(
        "sdpcase444444444444444444444444444444",
        result,
        context.state.participants
      );
      context.state.participants[result.userId].rtcPeer.processAnswer(
        result.sdpAnswer,
        function (error) {
          if (error) return console.error(error);
        }
      );
    },
    //case -6 video state를 받는다.
    videoStateTranslated(context, result) {
      if (result.video == 1) {
        context.state.participants[result.userId].videoStatus = true;
      } else {
        context.state.participants[result.userId].videoStatus = false;
      }
    },
    // participant.dispose에서 오는 요청
    disposeParticipant(context, participantName) {
      context.commit("disposeParticipant", participantName);
    },
    //다른 참가자 video 받기
    receiveVideo(context, sender) {
      console.log("receive다른사람 ", sender);
      var participant = new Participant(
        sender.userId,
        sender.video,
        sender.audio
      );
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
      //console.log("다른 참가자 video를 받습니다.", participant);
      //처음 입장시 내 헤드셋이 꺼져있다면 다른 참가자들의 마이크가 음소거된다.
      if (context.state.deafen) {
        video.muted = true;
      }
      context.commit("addParticipant", { name: sender.userId, participant });
    },
    setVoiceInfo(context, voiceInfo) {
      //console.log("voice방 정보 저장");
      context.commit("setVoiceInfo", voiceInfo);
    },
    sendMessage(context, message) {
      let jsonMessage = JSON.stringify(message);
      console.log("json", jsonMessage);
      context.state.ws.send(jsonMessage);
    },
    async leaveRoom(context) {
      console.log("leaveRoom");
      for (var key in context.state.participants) {
        context.state.participants[key].dispose();
      }
      context.state.ws.close();
      await context.commit("setWsOpen", false);
    },
  },
};

export default voice;
