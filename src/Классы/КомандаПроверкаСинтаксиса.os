#Использовать fs

Перем Конфигуратор;
Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "     Централизованная проверка конфигурации, в т.ч. полная проверка синтаксиса конфигурации.");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-name", "Строка подключения к хранилищу");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-user", "Пользователь хранилища");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--storage-pwd", "Пароль");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--junitpath", "Путь отчета в формате JUnit");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--allure-results",
		"Путь к каталогу сохранения результатов тестирования в формате Allure (xml)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--allure-results2",
		"Путь к каталогу сохранения результатов тестирования в формате Allure2 (json)");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--testsuitename",
		"Указать имя тестового набора в отчете JUnit для раздельной проверки в различных режимах");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--groupbymetadata",
		"Группировать проверки в по метаданным конфигурации");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--exception-file",
	"Путь файла с указанием пропускаемых исключений
	|	Формат файла: в каждой строке файла указан текст пропускаемого исключения или его часть
	|	Кодировка: UTF-8");
	Парсер.ДобавитьПараметрКоллекцияКоманды(ОписаниеКоманды, "--mode",
	"Параметры проверок (через пробел).
	|	Например, -ThinClient -WebClient -Server -ExternalConnection -ThickClientOrdinaryApplication
	|
	|Доступны следующие опции:
	|
	|    -ConfigLogIntegrity - проверка логической целостности конфигурации. Стандартная проверка, обычно выполняемая перед обновлением базы данных;
	|    -IncorrectReferences - поиск некорректных ссылок. Поиск ссылок на удаленные объекты. Выполняется по всей конфигурации, включая права, формы, макеты, интерфейсы и т.д. Также осуществляется поиск логически неправильных ссылок;
	|    -ThinClient - синтаксический контроль модулей для режима эмуляции среды управляемого приложения (тонкий клиент), выполняемого в файловом режиме;
	|    -WebClient - синтаксический контроль модулей в режиме эмуляции среды веб-клиента;
	|    -Server - синтаксический контроль модулей в режиме эмуляции среды сервера 1С:Предприятия;
	|    -ExternalConnection - синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в файловом режиме;
	|    -ExternalConnectionServer - синтаксический контроль модулей в режиме эмуляции среды внешнего соединения, выполняемого в клиент-серверном режиме;
	|    -MobileClient ‑ синтаксический контроль модулей в режиме эмуляции среды мобильного клиента;
	|    -MobileClientStandalone ‑ синтаксический контроль модулей в режиме эмуляции среды мобильного клиента, работающего в автономном режиме;
	|    -MobileAppClient - синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в клиентском режиме запуска;
	|    -MobileAppServer - синтаксический контроль модулей в режиме эмуляции среды мобильного приложения, выполняемого в серверном режиме запуска;
	|    -ThickClientManagedApplication - синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в файловом режиме;
	|    -ThickClientServerManagedApplication - синтаксический контроль модулей в режиме эмуляции среды управляемого приложения (толстый клиент), выполняемого в клиент-серверном режиме;
	|    -ThickClientOrdinaryApplication - синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в файловом режиме;
	|    -ThickClientServerOrdinaryApplication - синтаксический контроль модулей в режиме эмуляции среды обычного приложения (толстый клиент), выполняемого в клиент-серверном режиме;
	|    -DistributiveModules - поставка модулей без исходных текстов. В случае, если в настройках поставки конфигурации для некоторых модулей указана поставка без исходных текстов, проверяется возможность генерации образов этих модулей;
	|    -UnreferenceProcedures - поиск неиспользуемых процедур и функций. Поиск локальных (не экспортных) процедур и функций, на которые отсутствуют ссылки. В том числе осуществляется поиск неиспользуемых обработчиков событий;
	|    -HandlersExistence - проверка существования назначенных обработчиков. Проверка существования обработчиков событий интерфейсов, форм и элементов управления;
	|    -EmptyHandlers - поиск пустых обработчиков. Поиск назначенных обработчиков событий, в которых не выполняется никаких действий. Существование таких обработчиков может привести к снижению производительности системы;
	|    -ExtendedModulesCheck - проверка обращений к методам и свойствам объектов ""через точку"" (для ограниченного набора типов); проверка правильности строковых литералов - параметров некоторых функций, таких как ПолучитьФорму();
	|    -CheckUseModality - режим поиска использования в модулях методов, связанных с модальностью. Опция используется только вместе с опцией -ExtendedModulesCheck.
	|    -CheckUseSynchronousCalls ‑ режим поиска использования в модулях синхронных методов. Параметр используется только вместе с параметром -ExtendedModulesCheck.
	|    -UnsupportedFunctional - выполняется поиск функциональности, которая не может быть выполнена на мобильном приложении. Проверка в этом режиме показывает:
	|
	|        наличие в конфигурации метаданных, классы которых не реализованы на мобильной платформе;
	|        наличие в конфигурации планов обмена, у которых установлено свойство ""Распределенная информационная база"";
	|        использование типов, которые не реализованы на мобильной платформе:
	|            в свойствах ""Тип"" реквизитов метаданных, констант, параметров сеанса;
	|            в свойстве ""Тип параметра команды"" метаданного ""Команда"";
	|            в свойстве ""Тип"" реквизитов и колонок реквизита формы;
	|        наличие форм с типом формы ""Обычная"";
	|        наличие в форме элементов управления, которые не реализованы на мобильной платформе. Проверка не выполняется для форм, у которых свойство ""Назначение"" не предполагает использование на мобильном устройстве;
	|        сложный состав рабочего стола (использование более чем одной формы).
	|
	|    -Extension <Имя расширения> - обработка расширения с указанным именем. Если расширение успешно обработано возвращает код возврата 0, в противном случае (если расширение с указанным именем не существует или в процессе работы произошли ошибки) - 1;
	|    -AllExtensions - проверка всех расширений.
	|
	|ВНИМАНИЕ, ВАЖНО: этот параметр --MODE должен быть последним среди параметров!");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие -  (необязательно) дополнительные параметры
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ПутьОтчетаВФорматеJUnitxml = ПараметрыКоманды["--junitpath"];
	Если ПутьОтчетаВФорматеJUnitxml = Неопределено Тогда
		ПутьОтчетаВФорматеJUnitxml = "";
	Иначе
		СообщениеОшибки = "Генерация отчетов тестирования JUnit невозможна, т.к. не существуют каталоги:";
		МассивПутей = Новый Массив;
		МассивПутей.Добавить(ПутьОтчетаВФорматеJUnitxml);
		ОбщиеМетоды.ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(МассивПутей, СообщениеОшибки);
	КонецЕсли;

	МассивПутейАллюр = Новый Массив;

	ПутьОтчетаВФорматеAllure = ПараметрыКоманды["--allure-results"];
	Если ПутьОтчетаВФорматеAllure = Неопределено Тогда
		ПутьОтчетаВФорматеAllure = "";
	Иначе
		МассивПутейАллюр.Добавить(ПутьОтчетаВФорматеAllure);
	КонецЕсли;

	ПутьОтчетаВФорматеAllure2 = ПараметрыКоманды["--allure-results2"];
	Если ПутьОтчетаВФорматеAllure2 = Неопределено Тогда
		ПутьОтчетаВФорматеAllure2 = "";
	Иначе
		МассивПутейАллюр.Добавить(ПутьОтчетаВФорматеAllure2);
	КонецЕсли;

	СохранятьОтчетВФайл = ЗначениеЗаполнено(ПутьОтчетаВФорматеJUnitxml)
							ИЛИ ЗначениеЗаполнено(ПутьОтчетаВФорматеAllure)
							ИЛИ ЗначениеЗаполнено(ПутьОтчетаВФорматеAllure2);

	Если СохранятьОтчетВФайл И ЗначениеЗаполнено(МассивПутейАллюр) Тогда
		СообщениеОшибки = "Генерация отчетов тестирования Allure невозможна, т.к. не существуют каталоги:";
		ОбщиеМетоды.ОбеспечитьСуществованиеКаталогов(МассивПутейАллюр, СообщениеОшибки);
		Для Каждого ПутьАллюр Из МассивПутейАллюр Цикл
			ФС.ОбеспечитьПустойКаталог(ПутьАллюр);
		КонецЦикла;
	КонецЕсли;

	ИмяТестовогоНабора = ПараметрыКоманды["--testsuitename"];
	Если ИмяТестовогоНабора = Неопределено Тогда
		ИмяТестовогоНабора = "base";
	КонецЕсли;

	КоллекцияПроверок = ПараметрыКоманды["--mode"];

	ГруппироватьПоМетаданным = ПараметрыКоманды["--groupbymetadata"];
	ИмяФайлаИсключенийОшибок = ПараметрыКоманды["--exception-file"];

	ЛогПроверкиИзКонфигуратора = "";
	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
		МенеджерКонфигуратора.Инициализация(
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка
	);

	Лог.Информация("Начало проверки проекта");
	ДатаНачала = ТекущаяУниверсальнаяДата(); // UTC
	Попытка
		ОшибокНет = МенеджерКонфигуратора.ВыполнитьСинтаксическийКонтроль(
			КоллекцияПроверок,
			ЛогПроверкиИзКонфигуратора,
			ПараметрыКоманды["--storage-name"],
			ПараметрыКоманды["--storage-user"],
			ПараметрыКоманды["--storage-pwd"]);
	Исключение

		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());

	КонецПопытки;

	Лог.Информация("Проверка проекта завершена за %1с", Окр(ТекущаяУниверсальнаяДата() - ДатаНачала)); // UTC
	МенеджерКонфигуратора.Деструктор();

	РезультатТестирования = ОбработатьЛогОшибок(ДатаНачала, ЛогПроверкиИзКонфигуратора, ГруппироватьПоМетаданным, ИмяФайлаИсключенийОшибок);
	Если РезультатТестирования.КоличествоУпало = 0 Тогда
		ОшибокНет = Истина;
	КонецЕсли;

	Если СохранятьОтчетВФайл Тогда

		Лог.Отладка("ЛогПроверкиИзКонфигуратора %1", ЛогПроверкиИзКонфигуратора);
		Если НРег(СокрЛП(ЛогПроверкиИзКонфигуратора)) = "ошибок не обнаружено" Тогда
			ЛогПроверкиИзКонфигуратора = "";
		КонецЕсли;

		Если ЗначениеЗаполнено(ПутьОтчетаВФорматеAllure) Тогда

			Лог.Информация("Генерация отчета Allure");
			ГенерацияОтчетов.СформироватьОтчетВФорматеAllure(РезультатТестирования.ДатаНачала,
				РезультатТестирования, ПутьОтчетаВФорматеAllure, "Конфигуратор");

		КонецЕсли;

		Если ЗначениеЗаполнено(ПутьОтчетаВФорматеAllure2) Тогда

			Лог.Информация("Генерация отчета Allure2");
			ГенерацияОтчетов.СформироватьОтчетВФорматеAllure2(РезультатТестирования.ДатаНачала,
				РезультатТестирования, ПутьОтчетаВФорматеAllure2, "Конфигуратор");

		КонецЕсли;

		Если ЗначениеЗаполнено(ПутьОтчетаВФорматеJUnitxml) Тогда

			Лог.Информация("Генерация отчета JUnit");
			ГенерацияОтчетов.СформироватьОтчетВФорматеJUnit(РезультатТестирования,
				ПутьОтчетаВФорматеJUnitxml, ИмяТестовогоНабора);

		КонецЕсли;

	КонецЕсли;

	РезультатыКоманд = МенеджерКомандПриложения.РезультатыКоманд();

	Возврат ?(ОшибокНет, РезультатыКоманд.Успех, РезультатыКоманд.ОшибкаВремениВыполнения);

КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////////

Функция ОбработатьЛогОшибок(ДатаНачала, ЛогПроверкиИзКонфигуратора, ГруппироватьПоМетаданным, ИмяФайлаИсключенийОшибок)

	РезультатТестирования = Новый Структура;
	РезультатТестирования.Вставить("Ошибки", Новый Соответствие);
	РезультатТестирования.Вставить("ВсеОшибки", "");
	РезультатТестирования.Вставить("ДатаНачала", ДатаНачала);
	РезультатТестирования.Вставить("КоличествоПроверок", 0);
	РезультатТестирования.Вставить("КоличествоПропущено", 0);
	РезультатТестирования.Вставить("КоличествоУпало", 0);
	РезультатТестирования.Вставить("РазделитьВремя", ГруппироватьПоМетаданным);

	МассивСтрокИсключений = МассивСтрокИсключений();
	ПропускаемыеОшибки = СодержимоеФайлаИсключенийОшибок(ИмяФайлаИсключенийОшибок);
	ОбработанныйЛог = СтрЗаменить(ЛогПроверкиИзКонфигуратора, Символы.ВК + Символы.Таб, Символы.Таб);
	ОбработанныйЛог = СтрЗаменить(ОбработанныйЛог, Символы.ПС + Символы.Таб, Символы.Таб);

	Лог.Отладка("ОбработанныйЛог %1", ОбработанныйЛог);
	ИмяТестСценарияПредыдущаяСтрока = "Синтаксическая проверка конфигурации";

	ОставшиесяОшибки = ИзбавитьсяОтИсключений(ОбработанныйЛог, МассивСтрокИсключений);
	ОбработанныйЛог = СтрСоединить(ОставшиесяОшибки, Символы.ПС);

	Если НЕ ГруппироватьПоМетаданным Тогда
		Лог.Отладка("Ветка НЕ ГруппироватьПоМетаданным");

		Лог.Отладка("ОставшиесяОшибки %1", ОбработанныйЛог);
		Если Не ПустаяСтрока(ОбработанныйЛог) Тогда

			ОписаниеОшибкиТеста = ШаблонОписанияОшибки("Синтаксическая проверка конфигурации", ОбработанныйЛог);
			ДополнитьРезультатТекстомОшибки(РезультатТестирования, ОписаниеОшибкиТеста);
		КонецЕсли;
		Возврат РезультатТестирования;

	КонецЕсли;

	РезультатТестирования.ВсеОшибки = ОбработанныйЛог;

	Для Каждого ТекСтрока Из ОставшиесяОшибки Цикл

		ОписаниеОшибки = ПолучитьОписаниеОшибки(ТекСтрока, ИмяТестСценарияПредыдущаяСтрока);
		ДополнитьРезультатТекстомОшибки(РезультатТестирования, ОписаниеОшибки, ПропускаемыеОшибки, ТекСтрока);
	КонецЦикла;
	Возврат РезультатТестирования;

КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////////

// Определяем строки для исключения из ошибок
// См. стандарт "Обработчики событий модуля формы, подключаемые из кода"
// https://its.1c.ru/db/v8std#content:-2145783155:hdoc
Функция МассивСтрокИсключений()
	МассивСтрокИсключений = Новый Массив();
	МассивСтрокИсключений.Добавить(Нрег("Не обнаружено ссылок на процедуру: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("Не обнаружено ссылок на функцию: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("Пустой обработчик: ""Подключаемый_"));
	МассивСтрокИсключений.Добавить(Нрег("No links to function found: ""Attachable_"));
	МассивСтрокИсключений.Добавить(Нрег("No links to procedure found: ""Attachable_"));
	МассивСтрокИсключений.Добавить(Нрег("Empty handler: ""Attachable_"));

	// Исключаем из ошибок статус усшешного завершения тестирования
	МассивСтрокИсключений.Добавить(Нрег("Ошибок не обнаружено"));
	МассивСтрокИсключений.Добавить(Нрег("No syntax errors found"));
	МассивСтрокИсключений.Добавить(Нрег("No errors found"));

	Возврат МассивСтрокИсключений;
КонецФункции

Функция ИзбавитьсяОтИсключений(Знач ОбработанныйЛог, МассивСтрокИсключений)

	ОставшиесяОшибки = Новый Массив;
	Если ПустаяСтрока(ОбработанныйЛог) Тогда
		Возврат ОставшиесяОшибки;
	КонецЕсли;

	МассивСтрокОшибок = СтрРазделить(ОбработанныйЛог, Символы.ПС);
	Для Ит = 0 По МассивСтрокОшибок.Количество() - 1 Цикл

		ТекСтрока = МассивСтрокОшибок[Ит];
		Если СтрНачинаетсяС(ТекСтрока, "{") И НЕ (СтрНайти(ТекСтрока, " (Проверка ")
				ИЛИ СтрНайти(ТекСтрока, " (Проверка:")) Тогда
			ВтораяСтрока = СокрЛП(МассивСтрокОшибок[Ит + 1]);
			Если СтрНайти(ВтораяСтрока, " (Проверка") Тогда
				ТекСтрока = ТекСтрока + " #> " + СокрЛП(ВтораяСтрока);
				Ит = Ит + 1;
			КонецЕсли;
		КонецЕсли;

		Если ИсключитьСтроку(ТекСтрока, МассивСтрокИсключений) Тогда
			Продолжить;
		КонецЕсли;

		ОставшиесяОшибки.Добавить(ТекСтрока);
	КонецЦикла;

	Возврат ОставшиесяОшибки;
КонецФункции

Функция СодержимоеФайлаИсключенийОшибок(Знач ИмяФайлаИсключенийОшибок)

	Результат = Новый Массив;

	Если Не ЗначениеЗаполнено(ИмяФайлаИсключенийОшибок) Тогда

		Возврат Результат;

	КонецЕсли;

	Файл = Новый Файл(ИмяФайлаИсключенийОшибок);
	Если Не Файл.Существует() Тогда
		Возврат Результат;
	КонецЕсли;

	Лог.Отладка("Чтение файла исключений ошибок из %1", ИмяФайлаИсключенийОшибок);

	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаИсключенийОшибок, КодировкаТекста.UTF8);
	ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();
	Пока ПрочитаннаяСтрока <> Неопределено Цикл

		Если Не ПустаяСтрока(ПрочитаннаяСтрока) Тогда

			ДобавляемоеИсключение = НормализованныйТекстОшибки(ПрочитаннаяСтрока);
			Результат.Добавить(ДобавляемоеИсключение);
			Лог.Отладка("Добавлено в исключения: %1", ДобавляемоеИсключение);

		КонецЕсли;

		ПрочитаннаяСтрока = ЧтениеТекста.ПрочитатьСтроку();

	КонецЦикла;

	Лог.Отладка("Прочитано исключений: %1", Результат.Количество());
	Возврат Результат;

КонецФункции

Функция ИсключитьСтроку(Знач ПроверяемаяСтрока, Знач МассивСтрокИсключений)

	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда

		Возврат ИСТИНА;

	КонецЕсли;

	Для Каждого СтрИсключения Из МассивСтрокИсключений Цикл

		Если СтрНайти(НормализованныйТекстОшибки(ПроверяемаяСтрока), СтрИсключения) > 0 Тогда

			Возврат Истина;

		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция ПолучитьОписаниеОшибки(Знач СтрокаЛога, ИмяПоУмолчанию)

	Результат = ШаблонОписанияОшибки(ИмяПоУмолчанию);
	ЧастиСтрокиЛога = СтрРазделить(СокрЛП(СтрокаЛога), " ", Ложь);
	Если ЧастиСтрокиЛога.Количество() Тогда

		Результат.ИмяГруппы = ЧастиСтрокиЛога[0];
		ЧастиСтрокиЛога.Удалить(0);
		Результат.ТекстОшибки = СтрСоединить(ЧастиСтрокиЛога, " ");

	КонецЕсли;

	Если СтрНачинаетсяС(СтрокаЛога, "{") Тогда

		СтрокаЛога = СтрЗаменить(СтрокаЛога, "{", "");
		СтрокаЛога = СтрЗаменить(СтрокаЛога, "}", "");
		ПозицияСкобки = СтрНайти(СтрокаЛога, "(");

		Если ПозицияСкобки > 1 Тогда

			Результат.ИмяГруппы = Сред(СтрокаЛога, 1, ПозицияСкобки - 1);
			ПозицияВторойСкобки = СтрНайти(СтрокаЛога, ")", , ПозицияСкобки);
			Результат.НомерСтроки = Сред(СтрокаЛога, ПозицияСкобки + 1, ПозицияВторойСкобки - ПозицияСкобки - 1);
			Результат.ТекстОшибки = Сред(СтрокаЛога, ПозицияВторойСкобки + 3);
			Если НЕ СтрНайти(Результат.ТекстОшибки, " #> ") Тогда
				ПозСкобки = СтрНайти(Результат.ТекстОшибки, ")");
				Если ПозСкобки Тогда
					Результат.ТекстОшибки = Лев(Результат.ТекстОшибки, ПозСкобки) + " #> "
						+ СокрЛП(Сред(Результат.ТекстОшибки, ПозСкобки + 1));
				КонецЕсли;
			КонецЕсли;
		Иначе

			Результат.ИмяГруппы = ИмяПоУмолчанию;
			Результат.ТекстОшибки = СтрокаЛога;

		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ШаблонОписанияОшибки(ИмяПоУмолчанию, ТекстОшибки = "", НомерСтроки = 0, ТипОшибки = "Ошибка")

	Возврат Новый Структура("ТекстОшибки, ИмяГруппы, НомерСтроки, ТипОшибки", ТекстОшибки, ИмяПоУмолчанию,
		НомерСтроки, ТипОшибки);

КонецФункции

Функция СледуетПропуститьОшибку(Знач СтрокаСОшибкой, Знач ПропускаемыеОшибки)

	Если НЕ ЗначениеЗаполнено(ПропускаемыеОшибки) ИЛИ НЕ ЗначениеЗаполнено(СтрокаСОшибкой) Тогда

		Возврат Ложь;

	КонецЕсли;

	Для Каждого ТекИсключение Из ПропускаемыеОшибки Цикл
		Если СтрНайти(НормализованныйТекстОшибки(СтрокаСОшибкой), ТекИсключение) > 0 Тогда

			Возврат Истина;

		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция НормализованныйТекстОшибки(Знач ТекстОшибки)

	Возврат СокрЛП(НРег(ТекстОшибки));

КонецФункции

Процедура ДополнитьРезультатТекстомОшибки(Результат, ОписаниеОшибки, Знач ПропускаемыеОшибки = Неопределено,
		СтрокаЛога = "")

	Если СледуетПропуститьОшибку(СтрокаЛога, ПропускаемыеОшибки) Тогда

		ОписаниеОшибки.ТипОшибки = "Пропущено";

	КонецЕсли;

	ОшибкиГруппы = Результат.Ошибки.Получить(ОписаниеОшибки.ИмяГруппы);

	Если ОшибкиГруппы = Неопределено Тогда

		ОшибкиГруппы = Новый Соответствие();

	КонецЕсли;

	ОшибкиПоТипу = ОшибкиГруппы.Получить(ОписаниеОшибки.ТипОшибки);
	Если ОшибкиПоТипу = Неопределено Тогда

		Результат.КоличествоПроверок = Результат.КоличествоПроверок + 1;
		Если ОписаниеОшибки.ТипОшибки = "Ошибка" Тогда
			Результат.КоличествоУпало = Результат.КоличествоУпало + 1;
		Иначе
			Результат.КоличествоПропущено = Результат.КоличествоПропущено + 1;
		КонецЕсли;

		ОшибкиПоТипу = Новый Массив();

	КонецЕсли;

	ОшибкиПоТипу.Добавить(ОписаниеОшибки);
	ОшибкиГруппы.Вставить(ОписаниеОшибки.ТипОшибки, ОшибкиПоТипу);
	Результат.Ошибки.Вставить(ОписаниеОшибки.ИмяГруппы, ОшибкиГруппы);

КонецПроцедуры
