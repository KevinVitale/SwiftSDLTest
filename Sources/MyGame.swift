import SwiftSDL

@main final class MyGame: Game {
  #if !os(iOS)
  static var windowFlags: [SDL_WindowCreateFlag] {
    [
      .windowTitle("SwiftSDL Test"),
      .width(640), .height(480)
    ]
  }
  #endif
  
  deinit {
    print(#function)
  }
  
  private var iconBMP: (any Surface)!
  private var position: Point<Int32> = .zero
  
  func onReady(window: any SwiftSDL.Window) throws(SwiftSDL.SDL_Error) {
    #if !os(iOS)
    self.iconBMP = try SDL_Load(
      bitmap: "icon.bmp",
      inDirectory: "BMP"
    )
    #endif
  }
  
  func onUpdate(window: any SwiftSDL.Window, _ delta: SwiftSDL.Tick) throws(SwiftSDL.SDL_Error) {
    #if !os(iOS)
    let surface = try window.surface.get()
    try surface.clear(color: .gray)
    
    var rect: SDL_Rect = [
      self.position.x, self.position.y,
      self.iconBMP.w, self.iconBMP.h
    ]
    
    try iconBMP(
      SDL_BlitSurfaceScaled, nil,
      surface.pointer,
      .some(&rect),
      SDL_SCALEMODE_NEAREST
    )
    
    try window.updateSurface()
    #endif
  }
  
  func onEvent(window: any SwiftSDL.Window, _ event: SDL_Event) throws(SwiftSDL.SDL_Error) {
    #if !os(iOS)
    switch event.eventType {
      case .mouseMotion:
        self.position = event.motion.position(as: Int32.self)
        self.position &-= self.iconBMP.size / 2
      default: ()
    }
    #endif
  }
  
  func onShutdown(window: any SwiftSDL.Window) throws(SwiftSDL.SDL_Error) {
    iconBMP?.destroy()
  }
  
  /// Silences decoding errors for `(any Surface)!`...
  enum CodingKeys: CodingKey { /* no-op */ }
  
  required init() {
    #if os(iOS)
    SDL_SetHint(SDL_HINT_ORIENTATIONS, "Portrait")
    SDL_SetHint(SDL_HINT_RENDER_DRIVER, "metal")
    #endif
  }
}
