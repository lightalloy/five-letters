require "rainbow"

class Turn
  Result = Struct.new(:accepted, :text, :db)

  def initialize(user_word, guess_word, db:)
    @user_word = user_word
    @guess_word = guess_word
    @db = db
  end

  def call
    return Result.new(accepted: false, text: "Неверная длина слова") unless user_word.size == 5
    # не является словом
    return Result.new(accepted: false, text: "Не является словом") unless is_word?(user_word)
    response_word = ""
    our_word_chars = guess_word.chars
    user_word.chars.each_with_index do |char, i|
      # буква на месте
      if char == our_word_chars[i]
        response_word += Rainbow(" #{char} ").white.bg(:yellow)
      elsif our_word_chars.include?(char)
        response_word += Rainbow(" #{char} ").black.bg(:pink)
      else
        response_word += Rainbow(" #{char} ")
      end
    end
    Result.new(accepted: true, text: response_word)
  end

  private

  attr_reader :user_word, :guess_word, :db

  def is_word?(word)
    is_word = db.execute("select 1 from words where name = ? limit 1", word)
    is_word.size > 0
  end
end
