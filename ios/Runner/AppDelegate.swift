import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var privacyScreen: UIView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // App switcher'da ekranı gizle
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showPrivacyScreen),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(hidePrivacyScreen),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @objc private func showPrivacyScreen() {
    guard privacyScreen == nil else { return }
    
    let screen = UIView(frame: window?.bounds ?? UIScreen.main.bounds)
    screen.backgroundColor = UIColor.systemBackground
    
    // Logo veya kilit ikonu ekle
    let lockIcon = UIImageView(image: UIImage(systemName: "lock.shield.fill"))
    lockIcon.tintColor = .systemBlue
    lockIcon.contentMode = .scaleAspectFit
    lockIcon.translatesAutoresizingMaskIntoConstraints = false
    screen.addSubview(lockIcon)
    
    NSLayoutConstraint.activate([
      lockIcon.centerXAnchor.constraint(equalTo: screen.centerXAnchor),
      lockIcon.centerYAnchor.constraint(equalTo: screen.centerYAnchor),
      lockIcon.widthAnchor.constraint(equalToConstant: 80),
      lockIcon.heightAnchor.constraint(equalToConstant: 80)
    ])
    
    window?.addSubview(screen)
    privacyScreen = screen
  }
  
  @objc private func hidePrivacyScreen() {
    privacyScreen?.removeFromSuperview()
    privacyScreen = nil
  }
}
