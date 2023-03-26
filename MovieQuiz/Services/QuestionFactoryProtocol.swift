//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Fox on 26.03.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
