import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
  
  
  // Авторское решение:
  @IBAction private func noButtonClicked(_ sender: UIButton) {
    let currentQuestion = questions[currentQuestionIndex]
     let givenAnswer = false
     showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
  }
  
  // Авторское решение:
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
    let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
  }
  
  @IBOutlet private weak var counterLabel: UILabel!
  
  @IBOutlet private weak var imageView: UIImageView!
  
  @IBOutlet  private weak var textLabel: UILabel!

  // ПОПЫТКА ВРУЧНУЮ ДОАВИТЬ КАСТОМНЫЕ ШРИФТЫ, вызывает ошибки
  //textLabel.font = UIFont(name: "YSDisplay-Bold", size: 150)
  
  
  // для состояния "Вопрос задан"
  struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
  }

  // для состояния "Результат квиза"
  struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
  }

  struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
  }
  
  private let questions: [QuizQuestion] = [
          QuizQuestion(
              image: "The Godfather",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "The Dark Knight",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "Kill Bill",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "The Avengers",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "Deadpool",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "The Green Knight",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: true),
          QuizQuestion(
              image: "Old",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: false),
          QuizQuestion(
              image: "The Ice Age Adventures of Buck Wild",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: false),
          QuizQuestion(
              image: "Tesla",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: false),
          QuizQuestion(
              image: "Vivarium",
              text: "Рейтинг этого фильма больше чем 6?",
              correctAnswer: false)
      ]
  
  private var currentQuestionIndex: Int = 0
  private var correctAnswers: Int = 0
  
  private func show(quiz step: QuizStepViewModel) {
    // здесь мы заполняем нашу картинку, текст и счётчик данными
    counterLabel.text = step.questionNumber
    imageView.image = step.image
    textLabel.text = step.question
  }


  // здесь мы показываем результат прохождения квиза:
  private func show(quiz result: QuizResultsViewModel) {
    
    // создаём объекты всплывающего окна:
      let alert = UIAlertController(
          title: result.title,
          message: result.text,
          preferredStyle: .alert)
      
    // создаём для него кнопки с действиями
      let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
          self.currentQuestionIndex = 0
          
        // скидываем счётчик правильных ответов
        self.correctAnswers = 0
        
        
          // заново показываем первый вопрос
          let firstQuestion = self.questions[self.currentQuestionIndex]
          let viewModel = self.convert(model: firstQuestion)
          self.show(quiz: viewModel)
      }
      
    // добавляем в алерт кнопки
      alert.addAction(action)
    
    // показываем всплывающее окно
      self.present(alert, animated: true, completion: nil)
  }
  
  
  private func convert(model: QuizQuestion) -> QuizStepViewModel {
      return QuizStepViewModel(
          image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
          question: model.text, // берём текст вопроса
          questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    
  //  UIImage(imageLiteralResourceName: model.image
  }

  private func showAnswerResult(isCorrect: Bool) {
    if isCorrect {
            correctAnswers += 1
        }
    
    imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
    imageView.layer.borderWidth = 8 // толщина рамки
    imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    imageView.layer.borderColor = UIColor.white.cgColor
    
    imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
      self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
  }
  
  private func showNextQuestionOrResults() {
    if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
      // показать результат квиза
      let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
      let viewModel = QuizResultsViewModel(
                 title: "Этот раунд окончен!",
                 text: text,
                 buttonText: "Сыграть ещё раз")
             show(quiz: viewModel)
      
    } else {
  
      currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
      // показать следующий вопрос
      let nextQuestion = questions[currentQuestionIndex]
      let viewModel = convert(model: nextQuestion)
      show(quiz: viewModel)
      
    }
  }

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
      
      
      let currentQuestion = questions[currentQuestionIndex]
      
      show(quiz: convert(model: currentQuestion))
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      /*
      Тут имеет смысл дополнительно настроить наши изображения, например,
      задать цвет фона для экрана.
      */
    }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      /*
      Тут имеет смысл оповестить систему аналитики о том, что экран показался.
      */
    }
  
  override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     /*
     Тут имеет смысл остановить все процессы, которые происходили на этом экране.
     */
   }
  
  override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     /*
     Тут имеет смысл оповестить систему аналитики, что экран перестал показываться
     и привести его в изначальное состояние.
     */
   }
  
  
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
