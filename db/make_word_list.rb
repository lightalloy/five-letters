# формирование csv-файла со словами, к-е будут использоваться в игре

# словарь слов русского языка - http://www.opencorpora.org/files/export/dict/dict.opcorpora.txt.zip
# значение сокращений - https://www.opencorpora.org/dict.php?act=gram
DICT_FILE = File.join(File.dirname(__FILE__), "dict.txt")
# популярные слова русского языка, из репозитория https://github.com/hingston/russian
POPULAR_WORDS_FILE = File.join(File.dirname(__FILE__), "popular_words.txt")
# наши слова для игры - файл формируется этим скриптом
WORDS_FILE = File.join(File.dirname(__FILE__), "words.csv")

unless File.exist?(DICT_FILE)
  raise "Отсутствует файл словаря #{DICT_FILE}"
end

unless File.exist?(POPULAR_WORDS_FILE)
  raise "Отсутствует файл словаря #{POPULAR_WORDS_FILE}"
end

# очистим наш файл со словами (на случай, если там уже что-то есть)
File.truncate(WORDS_FILE, 0) if File.exist?(WORDS_FILE)

popular_words = []

File.foreach(POPULAR_WORDS_FILE) do |line|
  word = line.strip.downcase
  popular_words.push(word) if word.match?(/^[а-я]{5}$/)
end

words_cnt = 0

File.foreach(DICT_FILE) do |line|
  next unless line.include?("NOUN") && line.include?("nomn") # берём только существительные в именительном числе
  next if line.include?("plur") # отсеиваем множественное
  next if line.include?("Name") # отсеиваем имена
  next if line.include?("Surn") # отсеиваем фамилии
  next if line.include?("Patr") # отсеиваем отчества
  next if line.include?("Geox") # отсеиваем топонимы
  next if line.include?("Orgn") # отсеиваем организации
  next if line.include?("Abbr") # отсеиваем аббревиатуры

  word = line.split(" ").first.chomp.strip.downcase

  next if word.include?("-") # отсеиваем слова с дефисами
  next unless word.size == 5

  # отметим, как слово для загадывания, если оно не сленговое и не устаревшее
  # + популярное
  is_doubtful = (line.include?("Slng") || line.include?("Arch") || line.include?("Infr"))

  good_for_guess = (!is_doubtful && popular_words.include?(word)) ? "1" : "0"

  line = "#{word},#{good_for_guess}\n"

  File.write(WORDS_FILE, line, mode: "a")

  words_cnt += 1
end

puts "В csv-файл записано #{words_cnt} слов"
