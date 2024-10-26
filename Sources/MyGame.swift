import SwiftSDL

@main final class MyGame: Game {
  static var windowFlags: [SDL_WindowCreateFlag] {
    [
      .windowTitle("SwiftSDL Test"),
      .width(640), .height(480)
    ]
  }
  
  private var iconBMP: (any Surface)!
  private var position: Point<Int32> = .zero
  
  func onReady(window: any SwiftSDL.Window) throws(SwiftSDL.SDL_Error) {
    self.iconBMP = try SDL_Load(
      bitmap: "icon.bmp",
      inDirectory: "BMP"
    )
  }
  
  func onUpdate(window: any SwiftSDL.Window, _ delta: SwiftSDL.Tick) throws(SwiftSDL.SDL_Error) {
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
  }
  
  func onEvent(window: any SwiftSDL.Window, _ event: SDL_Event) throws(SwiftSDL.SDL_Error) {
    switch event.eventType {
      case .mouseMotion:
        self.position = event.motion.position(as: Int32.self)
        self.position &-= self.iconBMP.size / 2
      default: ()
    }
  }
  
  func onShutdown(window: any SwiftSDL.Window) throws(SwiftSDL.SDL_Error) {
    iconBMP?.destroy()
  }
  
  /// Silences decoding errors for `(any Surface)!`...
  enum CodingKeys: CodingKey { /* no-op */ }
  
  required init() { /* no-op */ }
}
