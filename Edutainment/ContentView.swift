//
//  ContentView.swift
//  Edutainment
//
//  Created by Rishav Gupta on 03/06/23.
//

import SwiftUI

struct Answers {
    @State var input = ""
}

struct ContentView: View {
    @State private var multiplyValue = 2
    @State private var numberOfQuestions = 5 {
        didSet {
            ContentView.noOfRows = numberOfQuestions
            answers = Array(repeating: "", count: ContentView.noOfRows)
            isAttempted = Array(repeating: false, count: ContentView.noOfRows)
            isAnswerCorrect = Array(repeating: false, count: ContentView.noOfRows)
        }
    }
    @State private var takingUserInput = true {
        didSet {
            if !takingUserInput {
                for _ in 0..<ContentView.noOfRows {
                    let randomValue = Int.random(in: 2..<101)
                    ContentView.randomMultiplications.append(randomValue)
                    ContentView.correctAnswers.append("\(multiplyValue * randomValue)")
                }
            }
        }
    }
    @State private var submitAnswers = false
    @State private var score = 0
    
    @State private var isAttempted = Array(repeating: false, count: ContentView.noOfRows)
    @State private var isAnswerCorrect = Array(repeating: false, count: ContentView.noOfRows)
    
//    @State private var multiplyAnswer = "" {
//        didSet {
//            ContentView.answers.append(multiplyAnswer)
//        }
//    }
    
    static var noOfRows: Int = 5
    
    @State private var answers: [String] = Array(repeating: "", count: ContentView.noOfRows)
    
    
    static var correctAnswers: [String] = []
    static var randomMultiplications: [Int] = []
    
    func multiplyText(index: Int) -> String {
        let randomValue = ContentView.randomMultiplications[index]
        return "\(multiplyValue) * \(randomValue)  = "
    }
    
    var body: some View {
        NavigationView {
            if takingUserInput {
                VStack {
                    Form {
                        Section {
                            HStack {
                                Spacer()
                                Text("Select number for multiplication")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                            }
                            Stepper("Multiplication by \(multiplyValue)", value: $multiplyValue, in: 2...20)
                        }
                        .listRowSeparator(.hidden)
                        
                        Section {
                            HStack {
                                Spacer()
                                Text("Answering capacity")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Button("5 questions") { numberOfQuestions = 5 }
                                    .padding(.all)
                                    .border(.green)
                                    .foregroundColor(numberOfQuestions == 5 ? .white : .green)
                                    .background(numberOfQuestions == 5 ? .green : .white)
                                
                                Spacer()
                                
                                Button("10 questions") { numberOfQuestions = 10 }
                                    .padding(.all)
                                    .border(.yellow)
                                    .foregroundColor(numberOfQuestions == 10 ? .white : .yellow)
                                    .background(numberOfQuestions == 10 ? .yellow : .white)
                            }
                            HStack {
                                Spacer()
                                Button("15 questions") { numberOfQuestions = 15 }
                                    .padding(.all)
                                    .border(.red)
                                    .foregroundColor(numberOfQuestions == 15 ? .white: .red)
                                    .background(numberOfQuestions == 15 ? .red : .white)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                    }
                    .navigationTitle("Learn Multiplication")
                    //                .scrollDisabled(true)
                    
                    Button("Let's go!") { takingUserInput = false }
                        .font(.title)
                }
            } else {
                VStack {
                    Form {
                        ForEach(0..<numberOfQuestions, id: \.self) { index in
                            HStack {
                                Text(multiplyText(index: index))
                                    .font(.title)
                                
                                VStack {
                                    TextField("Enter the result", text: Binding<String>(get: {
                                        answers[index]
                                    }, set: { newValue in
                                        answers[index] = newValue
                                        if !takingUserInput {
                                            isAttempted[index] = true
                                            if ContentView.correctAnswers[index] == newValue {
                                                isAnswerCorrect[index] = true
                                            }
                                        }
                                    }))
                                    
                                        .font(.callout)
                                        .padding([.top, .leading])
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(isAttempted[index] && isAnswerCorrect[index] ? .green : isAttempted[index] && !isAnswerCorrect[index] ? .red : .black)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                }
                            }
                        }
                    }
                    .navigationTitle("Challenge")
                    
                    Button("Submit", action: calculateScore)
                        .font(.title)
                }
                .alert("Your score", isPresented: $submitAnswers) {
                    Button("Restart", action: restartFlow)
                } message: {
                    Text("You scored \(score)")
                }
            }
        }
    }
    
    
    
    func calculateScore() {
        for index in 0..<ContentView.correctAnswers.count {
            if answers[index] == ContentView.correctAnswers[index] {
                score += 1
            }
        }
        submitAnswers = true
    }
    
    func restartFlow() {
        ContentView.randomMultiplications = []
        answers = Array(repeating: "", count: ContentView.noOfRows)
        score = 0
        ContentView.correctAnswers = []
        takingUserInput = true
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
