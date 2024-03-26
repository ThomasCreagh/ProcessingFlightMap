class ApplicationClass {
  private int m_timeLastFrame = 0;

  private ArrayList<Screen> m_screens = new ArrayList<Screen>();
  private Screen m_currentScreen;

  private FlightsManagerClass m_flightsManager = new FlightsManagerClass();
  private QueryManagerClass m_queryManager = new QueryManagerClass();

  private EventType<SwitchScreenEventInfoType> m_onSwitchEvent = new EventType<SwitchScreenEventInfoType>();

  ScreenCharts m_screenCharts = null;
  Screen3DFM m_screen3DFM = null;

  public void init() {
    m_queryManager.init();

    m_onSwitchEvent.addHandler(e -> switchScreen(e));

    initScreens();

    m_flightsManager.loadUSAndWorldFromFiles("hex_flight_data.bin", "hex_world_data.bin", 4, list -> {
      println("list.WORLD:" + list.US.length);
      m_screen3DFM.insertFlightData(list);
      m_screenCharts.loadData(list.US);
    }
    );
  }

  private void initScreens() {
    ScreenHome screenHome = new ScreenHome(SCREEN_1_ID);
    m_screens.add(screenHome);

    TwoDMapScreen screenFlightMap2D = new TwoDMapScreen(SCREEN_TWOD_MAP_ID, m_queryManager);
    m_screens.add(screenFlightMap2D);

    m_screen3DFM = new Screen3DFM(SCREEN_FLIGHT_MAP_ID, m_queryManager);
    m_screens.add(m_screen3DFM);

    m_screenCharts = new ScreenCharts(SCREEN_CHARTS_ID, m_queryManager);
    m_screens.add(m_screenCharts);

    m_currentScreen = screenHome;
    screenHome.init();
  }

  public void frame() {
    s_deltaTime = millis() - m_timeLastFrame;
    m_timeLastFrame = millis();

    m_currentScreen.draw();

    if (DEBUG_MODE && DEBUG_FPS_ENABLED) {
      fill(255, 0, 0, 255);
      textSize(15);
      float fps =  round(frameRate * 100.0) / 100.0;
      text("FPS: " + fps, width - 100, 10, 100, 100);
    }
  }

  void onMouseMoved() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseMoved();
  }

  void onMouseDragged() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseDragged();
  }

  void onMouseClick() {
    if (m_currentScreen != null)
      m_currentScreen.onMouseClick();
  }

  void onMouseWheel(int wheelCount) {
    if (m_currentScreen != null)
      m_currentScreen.getOnMouseWheelEvent().raise(new MouseWheelEventInfoType(mouseX, mouseY, wheelCount, m_currentScreen));
  }

  public void onKeyPressed(char k, int kc) {
    if (m_currentScreen != null)
      m_currentScreen.getOnKeyPressedEvent().raise(new KeyPressedEventInfoType(mouseX, mouseY, k, kc, m_currentScreen));
  }

  public EventType<SwitchScreenEventInfoType> getOnSwitchEvent() {
    return m_onSwitchEvent;
  }

  private void switchScreen(SwitchScreenEventInfoType e) {
    e.Widget.getOnMouseExitEvent().raise((EventInfoType)e);

    for (Screen screen : m_screens) {
      if (e.NewScreenId.compareTo(screen.getScreenId()) != 0)
        continue;

      m_currentScreen = screen;
      if (!m_currentScreen.m_initialised)
        m_currentScreen.init();
      return;
    }
  }
}

// Descending code authorship changes:
// F. Wright, Made ApplicationClass and set up init(), frame() and fixedFrame(), 8pm 23/02/24
// F. Wright, Modified onMouse() functions and merged functions from the old UI main into ApplicationClass, 6pm 04/03/24
// F. Wright, Changed manual profiling to use DebugProfilingClass instead, 2pm 06/03/24
// F. Wright, Fixed UI errors, 12pm 07/03/24
// CKM, bought code to working levels 14:00 12/03
// CKM, removed datapreprocessor references, 17:00 12/03
// M. Orlowski, added 2D screen, 11:00, 13/03
