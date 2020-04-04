//
//  ContentView.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/25/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import SwiftUI
import AppKit
import KingfisherSwiftUI

struct ContentView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    let defaults = UserDefaults.standard
    
    func setUserLastSeen() {
        let date = Date()
        defaults.set(date, forKey: "lastSeen")
    }
    
    func setUserLastClickedButton() {
        let date = Date()
        defaults.set(date, forKey: "lastClicked")
    }
    
    func restartApp() {
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
        exit(0)
    }
    
    func memeConfig() {
        let userLastSeen = defaults.object(forKey: "lastSeen")
        
        if userLastSeen != nil {
            let elapsedTimeBetweenSessions = Date().timeIntervalSince(userLastSeen as! Date)
            if elapsedTimeBetweenSessions > 14440 {
                //User hasn't been to the app in over 4 hours, so we go out to get the freshest memes.
                updateMemeList()
            } else {
                //Since this condition means the user has used the app in the last 4 hours, we feel comfortable just referencing the defaults. There is no need to fetch the list again.
                let random = defaults.array(forKey: "downloadedArrayOfMemes")!.randomElement()!
                meme = random as! String
            }
        } else {
            //Firs time user - we need to get them memes!
            updateMemeList()
        }
        setUserLastSeen()
    }
    
    func updateMemeList() {
        let memeURL = URL(string: "https://raw.githubusercontent.com/sabensm/TestRepo/master/memes.json")
        
        guard let url = memeURL else { return }
        
        if Reachability.isConnectedToNetwork(){
            _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                //Any errors?
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                
                //Is the response the correct / request successful?
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { debugPrint("Server Error")
                    return
                }
                //Make sure we have data
                guard let data = data else { return }
                // Parse JSON and cast as an array
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
                    let arrayOfMemes = json["memes"] as? Array ?? []
                    
                    //Get random image right away to display
                    let randomMemeFromArray = arrayOfMemes.randomElement()!
                    
                    //Take whole array and place into user defaults
                    self.defaults.set(arrayOfMemes, forKey: "downloadedArrayOfMemes")
                    
                    
                    DispatchQueue.main.async {
                        self.meme = (randomMemeFromArray as? String)!
                    }
                } catch {
                    debugPrint("JSON Error: \(error.localizedDescription)")
                }
            }.resume()
        }else{
            //Nothing really to do here. User is being displayed a message to connect to the internet.
        }
        
        
    }
    
    func getRandomImage() {
        //Due to the program possibly sitting in the menu bar with no dismissal of the main view, we're going to track the user pressing this button - if it's been 4 or more hours, we'll go out and fetch the new memes here as well.
        
        let userLastClicked = defaults.object(forKey: "lastClicked")
        let defaultsArray = defaults.array(forKey: "downloadedArrayOfMemes")
        
        if userLastClicked != nil {
            //check to see when the last tap was, and if it was over 4 hours ago, fetch new memes
            let elapsedTimeBetweenInteraciton = Date().timeIntervalSince(userLastClicked as! Date)
            if elapsedTimeBetweenInteraciton > 14440 {
                updateMemeList()
            } else {
                if defaultsArray != nil {
                    let random = defaultsArray?.randomElement()
                    meme = random as! String
                }
            }
        } else {
            //The user has never tapped this button, but we also know that they loaded the app successfully, so we can use an image from UserDefaults
            if defaultsArray != nil {
                let random = defaultsArray?.randomElement()
                meme = random as! String
            } else {
                self.alertTitle = "Unknown Error"
                self.alertMessage = "You did something that caused the program to enter a condition it really never should have. You can try quitting and restarting the app but we make no promises it will work"
                self.showAlert = true
                
            }
        }
        setUserLastClickedButton()
    }
    
    @State private var meme = ""
    @State private var showAlert = false
    
    //Alert variables
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    
    var body: some View {
        VStack() {
            HStack() {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 50, alignment: .center)
                    .padding(.top, 16)
            }
            if Reachability.isConnectedToNetwork() {
                KFImage(URL(string: meme))
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 3)
                .border(Color.black, width: 2.0)
                .padding(12)
            } else {
                Image("placeholder")
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 3)
                .border(Color.black, width: 2.0)
                .padding(12)
            }
            if Reachability.isConnectedToNetwork() {
                Button(action : {
                    self.getRandomImage()
                }) {
                    Text("Get Fresh Meme!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .buttonStyle(MyButtonStyle(color: .blue))
                .padding(.bottom, 10)
            } else {
                Button(action : {
                    self.restartApp()
                }) {
                    Text("No Connection Found. Click to Restart Once Connected")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .buttonStyle(MyButtonStyle(color: .red))
                .padding(.bottom, 10)
            }
            HStack {
                Button(action : {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Quit")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                Button(action : {
                    self.viewRouter.currentPage = "page2"
                }) {
                    Text("About")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }.padding(.bottom, 18)
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
        }
        .onAppear(perform: memeConfig)
        .onDisappear(perform: setUserLastSeen)
    }
}

struct MyButtonStyle: ButtonStyle {
    var color: Color = .green
    
    public func makeBody(configuration: MyButtonStyle.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5).fill(color))
            .compositingGroup()
            .shadow(color: .black, radius: 3)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(viewRouter: ViewRouter())
    }
}
