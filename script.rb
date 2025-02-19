require 'roo'
require 'csv'
require 'selenium-webdriver'

puts "🚀 Скрипт запущен."

# Настройки для Selenium (Chrome в headless режиме)
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--window-size=1920,1080')
options.add_argument('--disable-extensions')
options.add_argument('--disable-infobars')
options.add_argument('--disable-blink-features=AutomationControlled')
options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0 Safari/537.36')

# Инициализация драйвера
driver = Selenium::WebDriver.for(:chrome, options: options)

xlsx_files = Dir["*.xlsx"]

if xlsx_files.empty?
  puts "⚠️ Нет .xlsx файлов в текущей директории. Положите их сюда и перезапустите."
  exit
end

xlsx_files.each do |filename|
  puts "📂 Обработка файла: #{filename}..."

  begin
    # Открытие CSV с кодировкой Windows-1251
    output_file = CSV.open("#{filename}.csv", 'w', col_sep: ';', encoding: 'Windows-1251') do |csv|
      csv << ["Ссылка".encode('Windows-1251'), "Результат".encode('Windows-1251')]

      xlsx = Roo::Spreadsheet.open(filename)
      sheet = xlsx.sheet(xlsx.sheets.first)
      links = sheet.column('A')

      if links.compact.empty?
        puts "⚠️ Колонка 'A' в файле #{filename} пуста. Пропускаем."
        next
      end

      puts "🔍 Найдено #{links.size} ссылок. Начинаю обработку..."

      links.each_with_index do |link, i|
        next if link.nil? || link.strip.empty?

        puts "🔎 [#{i + 1}/#{links.size}] Открытие ссылки: #{link}"

        begin
          driver.navigate.to(link.to_s)
          sleep 3  # Ждем загрузку страницы

          # Проверка на "Товаров пока нет"
          no_goods_element = driver.find_elements(css: '#divGoodsNotFound > div > div > b').find { |el| el.text.include?("Товаров пока нет") }

          if no_goods_element
            puts "📝 Результат: Товаров пока нет"
            csv << [link.encode('Windows-1251'), "Товаров пока нет".encode('Windows-1251')]
            next
          end

          # Поиск количества товаров
          goods_count_element = driver.find_elements(css: '#catalog-seller > span > span').first

          if goods_count_element && !goods_count_element.text.strip.empty?
            product_count = goods_count_element.text.strip.gsub(/\s+/, '')
            puts "📝 Найдено количество товаров: #{product_count}"
            csv << [link.encode('Windows-1251'), product_count.encode('Windows-1251')]
          else
            puts "⚠️ Элементы не найдены. Записываем: Не найдено"
            csv << [link.encode('Windows-1251'), "Не найдено".encode('Windows-1251')]
          end

        rescue => e
          puts "❌ Ошибка при обработке ссылки #{link}: #{e.message}"
          csv << [link.encode('Windows-1251'), "Ошибка: #{e.message}".encode('Windows-1251')]
        end
      end
    end

    puts "✅ Завершена обработка файла: #{filename}. Результаты сохранены в #{filename}.csv."

  rescue => e
    puts "🚨 Ошибка при обработке файла #{filename}: #{e.message}"
  end
end

driver.quit
puts "🏁 Скрипт успешно завершил работу."
