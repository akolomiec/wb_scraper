# 📦 **Инструкция по установке и запуску проекта**

---

## 📝 **Описание проекта**

Этот проект позволяет автоматически парсить страницы продавцов на [Wildberries](https://www.wildberries.ru/) и извлекать информацию о наличии товаров или количестве доступных позиций.
- Если на странице продавца указано **"Товаров пока нет"**, скрипт сохранит эту информацию.
- Если указано количество товаров (например, **"1162 товара"**), оно будет записано в CSV.
- CSV-файл сохраняется в кодировке **Windows-1251** для корректного отображения в **Excel на Windows**.

---

## 🚀 **Требования**

- **Операционная система:** Ubuntu 20.04+
- **Ruby:** 2.7 или выше
- **Google Chrome:** Версия должна совпадать с используемым ChromeDriver
- **ChromeDriver:** Совместимая с установленной версией Chrome
- **Docker (опционально):** Для изоляции окружения

---

## 🛠️ **Установка**

### ✅ **1. Установка Ruby и необходимых пакетов**

```bash
sudo apt update
sudo apt install -y ruby-full wget unzip xvfb libxi6 libgconf-2-4 default-jdk build-essential
```

### ✅ **2. Установка Google Chrome**
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
google-chrome --version  # Проверка версии Chrome
```
### ✅ **3. Установка ChromeDriver**

1. Определите версию установленного Chrome:

```bash
google-chrome --version
```

2. Скачайте соответствующий ChromeDriver (пример для версии 133.0.6943.126):

```bash
wget https://storage.googleapis.com/chrome-for-testing-public/133.0.6943.126/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
sudo mv chromedriver-linux64/chromedriver /usr/local/bin/
sudo chmod +x /usr/local/bin/chromedriver
chromedriver --version  # Проверка версии
```

### ✅ **4. Установка необходимых Ruby-библиотек**

```bash
gem install bundler
bundle init
```

В Gemfile добавьте:

```ruby
gem 'roo'
gem 'csv'
gem 'selenium-webdriver'
```

Затем установите зависимости:

```bash
bundle install
```

Или установите напрямую:

```bash
gem install roo selenium-webdriver csv
```

---

### 🗂️ **Структура проекта**
```graphql
project/
├── script.rb          # Основной скрипт для парсинга
├── input.xlsx         # Исходный Excel-файл с ссылками (в колонке A)
├── output.xlsx.csv    # CSV с результатами
└── README.md          # Документация проекта
```
---

### 🚀 **Запуск проекта**
1. Подготовьте файл input.xlsx с ссылками на страницы продавцов в колонке A.

2. Запустите скрипт:

```bash
ruby script.rb
```

3. После завершения работы скрипт создаст файл input.xlsx.csv с результатами.

### 📊 **Формат CSV-выходных данных**
| Ссылка	                             | Результат         |
|---------------------------------------|-------------------|
| https://www.wildberries.ru/seller/1   | 	Товаров пока нет |
| https://www.wildberries.ru/seller/202 | 1162              |
| https://www.wildberries.ru/seller/999 | 	Не найдено       | 

- Файл сохраняется в кодировке Windows-1251 для поддержки русских символов в Excel.

### 🧪 **Рекомендации при запуске**

- Используйте стабильное интернет-соединение, так как скрипт загружает страницы в реальном времени.
- Если Wildberries начнет блокировать запросы, увеличьте задержку между запросами (sleep 3 → sleep 5).
- Для больших списков ссылок рекомендуется использовать запуск в Docker для изоляции среды.

---

### 🐞 **Отладка и распространенные ошибки**
- Ошибка HTTP (403/429):
  - Wildberries заблокировал IP из-за слишком частых запросов. Добавьте задержку или используйте прокси.

- Ошибка ChromeDriver not found:
  - Убедитесь, что chromedriver установлен и находится в /usr/local/bin/.

- Кодировка в CSV отображается некорректно:
  - Откройте CSV в Excel с указанием кодировки Windows-1251.

---

### 🧹 **Удаление и очистка**

```bash
rm -rf chromedriver-linux64.zip chromedriver-linux64
sudo rm /usr/local/bin/chromedriver
```
--- 

### 🤝 **Контакты и поддержка**

Если возникли вопросы или проблемы — обращайтесь!

📧 Email: [protechnologii22@yandex.ru](mailto:protechnologii22@yandex.ru)

🐛 Issues: [GitHub Repository Issues](https://github.com/akolomiec/wb_scraper/issues)