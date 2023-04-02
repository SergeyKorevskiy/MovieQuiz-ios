//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Fox on 26.03.2023.
//

import Foundation

/*
 1 - Создаём протокол QuestionFactoryDelegate, который будем использовать в фабрике как делегата.
Мы ограничиваем наш протокол классами, используя AnyObject — это пригодится дальше при создании слабых ссылок на делегат.
Мы ограничиваем наш протокол классами, используя AnyObject — это пригодится дальше при создании слабых ссылок на делегат.
2 - Объявляем метод, который должен быть у делегата фабрики.
 */


protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
