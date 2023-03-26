//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Fox on 23.03.2023.
//

import Foundation

// : QuestionFactoryProtocol - добавить протокол??

class QuestionFactory {

  static private let quizQuestion: String = "Рейтинг этого фильма больше чем 6?"
  
  private let questions: [QuizQuestion] = [
    QuizQuestion(
      image: "The Godfather",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "The Dark Knight",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "Kill Bill",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "The Avengers",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "Deadpool",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "The Green Knight",
      text: quizQuestion,
      correctAnswer: true),
    QuizQuestion(
      image: "Old",
      text: quizQuestion,
      correctAnswer: false),
    QuizQuestion(
      image: "The Ice Age Adventures of Buck Wild",
      text: quizQuestion,
      correctAnswer: false),
    QuizQuestion(
      image: "Tesla",
      text: quizQuestion,
      correctAnswer: false),
    QuizQuestion(
      image: "Vivarium",
      text: quizQuestion,
      correctAnswer: false)
  ]
  
  func requestNextQuestion() -> QuizQuestion? {                       // 1
      guard let index = (0..<questions.count).randomElement() else {  // 2
          return nil
      }
      return questions[safe: index]                           // 3
  }
  
}
