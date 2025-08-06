//
//  ContentView.swift
//  GuesstheFlag
//
//  Created by gülçin çetin on 12.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var questionCount = 0
    @State private var showingFinalScore = false
    
    @State private var selectedFlag : Int? = nil

    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.1, blue: 0.20), location: 0.3),
                    .init(color: Color(red: 0.10, green: 0.15, blue: 0.30), location: 0.3),
                ], center: .top, startRadius: 100, endRadius: 400)
                    .ignoresSafeArea()
                VStack(spacing: 30){
                        Text("Guess the flag")
                        .titleStyle()
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.white)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    ForEach(0..<3){ flagIndex in
                        Button{
                            flagTapped(flagIndex)
                        }label: {
                            FlagView(country: countries[flagIndex])
                             .rotation3DEffect(
                                 .degrees(selectedFlag == flagIndex ? 180 : 0),
                                  axis: (x:0, y:1, z:0)
                                )
                             .opacity(selectedFlag == nil || selectedFlag == flagIndex ? 1 : 0.25)
                             .scaleEffect(selectedFlag == nil || selectedFlag == flagIndex ? 1 : 0.8)
                             .animation(.easeInOut(duration: 0.5), value: selectedFlag)
                            }
                    }
                }
            }
            .alert(scoreTitle, isPresented: $showingScore){
                Button("Continune",action: askQuestion)
            } message: {
                Text("Your score is \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())            }
            .alert("Final score is \(score)", isPresented: $showingFinalScore){
                Button("Restart", action: resetGame)
            } message: {
                Text("Tap to restart")
            }
        }
    }
    
    func flagTapped(_ tappedFlagIndex: Int){
        selectedFlag = tappedFlagIndex // <- store which flag was tapped
        
        questionCount += 1
        
        if tappedFlagIndex == correctAnswer{
            scoreTitle = "Correct!"
            score += 20
        }else{
            scoreTitle = "Wrong! its the flag of \(countries[tappedFlagIndex])."
        }
        
        if questionCount == 5 {
            showingFinalScore = true
        }else {
            showingScore = true
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil // <- reseting for next round
    }
    func resetGame(){
        score = 0
        questionCount = 0
        askQuestion()
        
    }
}

struct FlagView : View {
    var country : String
    
    var body: some View {
        Image(country)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
    }
}

struct Title : ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
            .padding()
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

#Preview {
    ContentView()
}


