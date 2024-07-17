class Game
  # результат - сдался, отгадал, не отгадал
  Result = Struct.new(:state)

  def initialize(guess_word:, db: , max_tries: 5)
    @guess_word = guess_word
    @max_tries = max_tries
    @db = db
  end

  def play
    turn_num = 1
    until turn_num > max_tries do
      puts "Попытка: #{turn_num}"
      user_word = STDIN.gets.strip
      if user_word.downcase == "сдаюсь"
        return Result.new(state: "give-up")
      else
        turn_result = Turn.new(user_word, guess_word, db: db).call
        puts turn_result.text
        if user_word == guess_word
          return Result.new(state: "success")
        end
        turn_num += 1 if turn_result.accepted
      end
    end
    Result.new(state: "not-guessed")
  end

  private

  attr_reader :guess_word, :db, :max_tries
end