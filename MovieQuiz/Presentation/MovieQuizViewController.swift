import UIKit

// 14.03.2023
final class MovieQuizViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction private func noButtonClicked(_ sender: UIButton) {
    guard let currentQuestion = currentQuestion else {
        return
    }
    let givenAnswer = false
    showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
  }
  
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
    guard let currentQuestion = currentQuestion else {
        return
    }
    let givenAnswer = true
    showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
  }
  
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet  private weak var textLabel: UILabel!
  
  private var currentQuestionIndex: Int = 0
  private var correctAnswers: Int = 0
  
  private let questionsAmount: Int = 10
  private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
  private var currentQuestion: QuizQuestion?
  
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
    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
      guard let self = self else { return }
      
      self.currentQuestionIndex = 0
      
      // скидываем счётчик правильных ответов
      self.correctAnswers = 0
      
      // заново показываем первый вопрос
      if let firstQuestion = self.questionFactory.requestNextQuestion() {
          self.currentQuestion = firstQuestion
          let viewModel = self.convert(model: firstQuestion)
          
          self.show(quiz: viewModel)
      }
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
                  questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
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
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      guard let self = self else { return }
      self.showNextQuestionOrResults()
      self.imageView.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  private func showNextQuestionOrResults() {
    
    if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
      // показать результат квиза
        let text = correctAnswers == questionsAmount ?
                "Поздравляем, Вы ответили на 10 из 10!" :
                "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
    
      let viewModel = QuizResultsViewModel(
        title: "Этот раунд окончен!",
        text: text,
        buttonText: "Сыграть ещё раз")
      show(quiz: viewModel)
      
    } else {
      
      currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
      // показать следующий вопрос
      if let nextQuestion = questionFactory.requestNextQuestion() {
          currentQuestion = nextQuestion
          let viewModel = convert(model: nextQuestion)
          
          show(quiz: viewModel)
      }
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    if let firstQuestion = questionFactory.requestNextQuestion() {
        currentQuestion = firstQuestion
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
    }
    
    
  }
  
}
