const utils = {
  namespaced: true,
  state: {
    //마우스 좌표를 위한 변수
    clientX: 0,
    clientY: 0,
    //Socket연결을 관리하기 위한 변수
    stompSocketClient: null,
    stompSocketConnected: false,
    //알림용 토큰
    webPushToken: null,
    //navigationBar의 선택된 커뮤니티를 알기 위한 변수
    navigationSelected: "@me",
  },
  mutations: {
    setClientX(state, clientX) {
      state.clientX = clientX;
    },
    setClientY(state, clientY) {
      state.clientY = clientY;
    },
    setStompSocketClient(state, stompSocketClient) {
      state.stompSocketClient = stompSocketClient;
    },
    setStompSocketConnected(state, stompSocketConnected) {
      state.stompSocketConnected = stompSocketConnected;
    },
    setNavigationSelected(state, navigationSelected) {
      state.navigationSelected = navigationSelected;
    },
    setWebPushToken(state, webPushToken) {
      state.webPushToken = webPushToken;
    },
  },
};

export default utils;
