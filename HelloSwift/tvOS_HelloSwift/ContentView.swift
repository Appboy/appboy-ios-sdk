import SwiftUI
import AppboyTVOSKit

struct ContentView: View {
    var body: some View {
      Text("Logged Custom Event 'hello-tv-OS' to Braze for user " + Appboy.sharedInstance()?.getDeviceId())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
