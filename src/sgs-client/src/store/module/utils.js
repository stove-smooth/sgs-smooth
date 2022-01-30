const utils = {
  namespaced: true,
  state: {
    clientX: 0,
    clientY: 0,
    stompSocketClient: null,
    stompSocketConnected: false,
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
