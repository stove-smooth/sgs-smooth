const utils = {
  namespaced: true,
  state: {
    //마우스 좌표를 위한 변수
    clientX: 0,
    clientY: 0,
    //Socket연결을 관리하기 위한 변수
    stompSocketClient: null,
    stompSocketConnected: false,
    //navigationBar의 선택된 커뮤니티를 알기 위한 변수
    navigationSelected: "@me",
  },
  getters: {
    getStompSocketClient: (state) => {
      return state.stompSocketClient;
    },
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
  },
};

export default utils;
