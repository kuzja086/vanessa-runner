///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Запуск тестирования через фреймворк Vanessa-ADD
//
//	oscript src/main.os xunit C:\projects\add\tests\smoke
//		--reportsxunit "ГенераторОтчетаJUnitXML{build/junit.xml};ГенераторОтчетаAllureXMLВерсия2{build/allure.xml}"
//		--reportsxunit "GenerateReportJUnitXML{build/junit.xml};GenerateReportAllureXML{build/allure.xml}"
//
// TODO добавить фичи для проверки команды тестирования Vanessa-ADD
//
// Служебный модуль с набором методов работы с командами приложения
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать v8runner
#Использовать asserts
#Использовать fs

Перем Лог;
Перем МенеджерКонфигуратора;
Перем ВанессаАДД;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ВанессаАДД = ОбщиеМетоды.ЗагрузитьВанессаАДД();
	Если ВанессаАДД = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("addRoot", ВанессаАДД.КаталогИнструментов());

	ТекстОписания =
		"     Запуск тестирования через фреймворк Vanessa-ADD (Vanessa Automation Driven Development).";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "testsPath",
		"[env RUNNER_TESTSPATH] Путь к каталогу или к файлу с тестами
		|или к встроенным тестам, если явно указан ключ --config-tests.
		|Возможные варианты указания подсистемы или конкретного теста:
		|	Метаданные.Подсистемы.Тестовая
		|	Метаданные.Подсистемы.Тестовая.Подсистемы.Подсистема1
		|	Метаданные.Обработки.Тест");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--workspace",
		"
		|[env RUNNER_WORKSPACE] путь к папке, относительно которой будут определяться макросы $workspace.
		|                 по умолчанию текущий.");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--config-tests",
		"[env RUNNER_CONFIG_TESTS] загружать тесты, встроенные в конфигурации в указанную подсистему");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--pathxunit",
			"[env RUNNER_PATHXUNIT] путь к внешней обработке, по умолчанию ищу в пакете vanessa-add");

	ОписаниеОтчетов = "    --reportsxunit параметры формирования отчетов в формате вида:";
	ОписаниеОтчетов  = ОписаниеОтчетов  +
		"      ФорматВыводаОтчета{Путь к файлу отчета};ФорматВыводаОтчета{Путь к файлу отчета}...";
	ОписаниеОтчетов  = ОписаниеОтчетов  +
		"      Пример:							ГенераторОтчетаJUnitXML{build/junit.xml};ГенераторОтчетаAllureXML{build/allure.xml}";
	ОписаниеОтчетов  = ОписаниеОтчетов  +
		"      Пример (англоязычный вариант):	GenerateReportJUnitXML{build/junit.xml};GenerateReportAllureXML{build/allure.xml}";
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--reportsxunit", ОписаниеОтчетов);

	ОписаниеСтатуса = "    --xddExitCodePath путь к текстовому файлу, обозначающему статус выполнению.";
	ОписаниеСтатуса  = ОписаниеСтатуса  + "    Внутри файла строка-значение 0 (тесты пройдены), 1 (тесты не пройдены)";

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--xddExitCodePath", ОписаниеСтатуса);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--xddConfig", "Путь к конфигурационному файлу xUnitFor1c");

	ОписаниеТестКлиент = "Параметры подключения к тест-клиенту вида --testclient ИмяПользователя:Пароль:Порт";
	ОписаниеТестКлиент = ОписаниеТестКлиент +
		"    Пример 1: --testclient Администратор:пароль:1538";
	ОписаниеТестКлиент = ОписаниеТестКлиент +
		"    Пример 2: --testclient ::1538 (клиент тестирования будет запущен с реквизитами менеджера тестирования)";
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--testclient", ОписаниеТестКлиент);

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
			"--reportxunit", "путь к каталогу с отчетом jUnit (устарел)");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--additional",
			"Дополнительные параметры для запуска предприятия.");

	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-wait",
		"Не ожидать завершения запущенной команды/действия");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--xdddebug",
		"Выводить отладочные сообщения при прогоне тестов");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--no-shutdown",
		"Не завершать работу 1С:Предприятие после выполнения тестов");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Попытка
		Лог = ДополнительныеПараметры.Лог;
	Исключение
		Лог = Логирование.ПолучитьЛог(ПараметрыСистемы.ИмяЛогаСистемы());
	КонецПопытки;

	ЗапускатьТолстыйКлиент = ОбщиеМетоды.УказанПараметрТолстыйКлиент(ПараметрыКоманды["--ordinaryapp"], Лог);
	ОжидатьЗавершения = Не ПараметрыКоманды["--no-wait"];

	ПараметрыОтчетовXUnit = ПараметрыОтчетовXUnit(ПараметрыКоманды["--reportsxunit"],
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--reportxunit"]));

	ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(ПараметрыОтчетовXUnit);

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Инициализация(
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"], ПараметрыКоманды["--uccode"],
		ДанныеПодключения.КодЯзыка, ДанныеПодключения.КодЯзыкаСеанса
	);

	Попытка
		ЗапуститьТестироватьЮнит(
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["testsPath"]),
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--workspace"]),
			ПараметрыОтчетовXUnit,
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--xddExitCodePath"]),
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--pathxunit"]), ЗапускатьТолстыйКлиент,
			ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--xddConfig"]),
			ОжидатьЗавершения,
			ПараметрыКоманды["--additional"],
			ПараметрыКоманды["--config-tests"],
			ПараметрыКоманды["--testclient"],
			ПараметрыКоманды["--xdddebug"],
			Не ПараметрыКоманды["--no-shutdown"]
		);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение;
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду

// Выполняем запуск тестов для xunit
//
// Параметры:
//	ПутьВходящихДанных - <Строка> - Может принимать путь к каталогу, так и к файлу для тестирования,
//		или пути к встроенным тестам
//	РабочийКаталогПроекта - <Строка> - Путь к каталогу с проектом, по умолчанию каталог ./
//	ФормируемыеОтчеты - <Структура> - Коллекция описания формирования отчетов тестирования
//  ПутьФайлаСтатусаТестирования - <Строка> - путь к файлу статуса тестирования
//  ПутьКИнструментам - <Строка> - путь к инструментам, по умолчанию ./tools/xUnitFor1C/xddTestRunner.epf
//  ТолстыйКлиент -  Булево, Неопределено - признак запуска толстого клиента
//	ДопПараметры - <Строка> - дополнительные параметры для передачи в параметры запуска 1с, например /DebugURLtcp://localhost
//  ЗагружатьВстроенныеТесты - <Булево> - Загружать тесты, встроенные в конфигурацию
//  ТестКлиент - <Строка> - Параметры подключения к тест-клиенту
//  ВключенаОтладкаТестирования - Булево -
//  Завершать1СПослеТестирования - Булево -
//
Процедура ЗапуститьТестироватьЮнит(Знач ПутьВходящихДанных,
										Знач РабочийКаталогПроекта,
										Знач ФормируемыеОтчеты,
										Знач ПутьФайлаСтатусаТестирования,
										Знач ПутьКИнструментам, Знач ТолстыйКлиент,
										Знач ПутьККонфигурационномуФайлу,
										Знач ОжидатьЗавершения,
										Знач ДопПараметры,
										Знач ЗагружатьВстроенныеТесты,
										Знач ТестКлиент,
										Знач ВключенаОтладкаТестирования,
										Знач Завершать1СПослеТестирования)

	Лог.Информация("Выполняю тесты  с помощью фреймворка Vanessa-ADD (Vanessa Automation Driven Development) - %1", ПутьВходящихДанных);

	Если Не ЗначениеЗаполнено(РабочийКаталогПроекта) Тогда
		РабочийКаталогПроекта = "./";
	КонецЕсли;
	РабочийКаталогПроекта = ОбщиеМетоды.ПолныйПуть(РабочийКаталогПроекта);

	Если ПустаяСтрока(ПутьКИнструментам) Тогда
		ПутьКИнструментам = ВанессаАДД.ПутьИнструментаТДД();
	КонецЕсли;

	ФайлСуществует = Новый Файл(ПутьКИнструментам).Существует();
	Ожидаем.Что(ФайлСуществует, СтрШаблон("Ожидаем, что файл <%1> существует, а его нет!", ПутьКИнструментам)).ЭтоИстина();

	Если Не ЗагружатьВстроенныеТесты Тогда
		Если Новый Файл(ПутьВходящихДанных).ЭтоКаталог() Тогда
			КлючЗапуска = """xddRun ЗагрузчикКаталога """"" + ПутьВходящихДанных + """"";";
		Иначе
			КлючЗапуска = """xddRun ЗагрузчикФайла """"" + ПутьВходящихДанных + """"";";
		КонецЕсли;
	Иначе
		КлючЗапуска = """xddRun ЗагрузчикИзПодсистемКонфигурации """"" + ПутьВходящихДанных + """"";";
	КонецЕсли;

	Если Не ПустаяСтрока(ТестКлиент) Тогда
		КлючЗапуска = КлючЗапуска +
				СтрШаблон(" xddTestClient """"%1"""" ; ", ТестКлиент);
	КонецЕсли;

	Для каждого ПараметрыОтчета Из ФормируемыеОтчеты Цикл
		Генератор = СтрЗаменить(ПараметрыОтчета.Ключ, "GenerateReport", "ГенераторОтчета");
		КлючЗапуска = КлючЗапуска + "xddReport " + Генератор + " """"" + ПараметрыОтчета.Значение + """"";";
	КонецЦикла;

	Если Не ПустаяСтрока(ПутьККонфигурационномуФайлу) Тогда
		КлючЗапуска = КлючЗапуска +
				СтрШаблон(" xddConfig """"%1"""" ; ", ПутьККонфигурационномуФайлу);
	КонецЕсли;

	Если Не ПустаяСтрока(ПутьФайлаСтатусаТестирования) Тогда
		КлючЗапуска = КлючЗапуска +
				СтрШаблон(" xddExitCodePath ГенерацияКодаВозврата """"%1"""" ; ", ПутьФайлаСтатусаТестирования);
	КонецЕсли;

	НастройкиДля1С.ДобавитьШаблоннуюПеременную("workspaceRoot", РабочийКаталогПроекта);

	Настройки = НастройкиДля1С.ПрочитатьНастройки(ПутьККонфигурационномуФайлу);

	ПутьЛогаВыполненияСценариев = НастройкиДля1С.ПолучитьНастройку(Настройки, "ИмяФайлаЛогВыполненияСценариев",
								"./build/xddonline.txt", "путь к лог-файлу выполнения");

	Если ВключенаОтладкаТестирования Тогда
		КлючЗапуска = КлючЗапуска + " debug ; ";
	КонецЕсли;

	КлючЗапуска = КлючЗапуска + " workspaceRoot """"" + РабочийКаталогПроекта + """"" ; ";

	Если Завершать1СПослеТестирования Тогда
		КлючЗапуска = КлючЗапуска + " xddShutdown ";
	КонецЕсли;

	КлючЗапуска = КлючЗапуска + " """;

	Лог.Отладка(КлючЗапуска);

	ДополнительныеКлючи = " /TESTMANAGER " + ДопПараметры;

	ДопСообщения = МенеджерКонфигуратора.НовыеДопСообщенияДляЗапускаПредприятия();
	ДопСообщения.Ключ = "ЗапуститьТестироватьЮнит";
	ДопСообщения.ПоказыватьДополнительноЛогПредприятия = Ложь;
	ДопСообщения.СообщениеВСлучаеУспеха = "Все тесты выполнены!";
	ДопСообщения.СообщениеВСлучаеПадения = "Часть тестов упала!";
	ДопСообщения.СообщениеВСлучаеПропуска = "Ошибок при тестировании не найдено, но часть тестов еще не реализована!";

	МенеджерКонфигуратора.ЗапуститьВРежимеПредприятияСПроверкойВыполнения(
		ДопСообщения,
		КлючЗапуска, ПутьКИнструментам,
		ТолстыйКлиент, ДополнительныеКлючи, ОжидатьЗавершения,
		ПутьЛогаВыполненияСценариев, ПутьФайлаСтатусаТестирования);

	Лог.Информация("Выполнение тестов завершено");

КонецПроцедуры // ЗапуститьТестироватьЮнит()

Функция ПараметрыОтчетовXUnit(Знач ПереданныеПараметрыОтчетов, Знач ВыходнойКаталогОтчета = "")
	НаборПараметров = Новый Структура;

	Если Не ПустаяСтрока(ВыходнойКаталогОтчета) Тогда
		НаборПараметров.Вставить("ГенераторОтчетаJUnitXML", ВыходнойКаталогОтчета);
	КонецЕсли;

	Если Не ПустаяСтрока(ПереданныеПараметрыОтчетов) Тогда
		ПараметрыВыводаОтчетов = СтрРазделить(ПереданныеПараметрыОтчетов, ";");
		Для каждого ПараметрВывода Из ПараметрыВыводаОтчетов Цикл
			ПозицияОткрывающейСкобки = СтрНайти(ПараметрВывода, "{");
			ПозицияЗакрывающейСкобки = СтрНайти(ПараметрВывода, "}");

			ФорматВывода = СокрЛП(Лев(ПараметрВывода, ПозицияОткрывающейСкобки - 1));

			ПереданныйПуть = СокрЛП(Сред(ПараметрВывода, ПозицияОткрывающейСкобки + 1,
							ПозицияЗакрывающейСкобки - ПозицияОткрывающейСкобки - 1));

			ПутьВывода = ОбщиеМетоды.ПолныйПуть(ПереданныйПуть);

			НаборПараметров.Вставить(ФорматВывода, ПутьВывода);
		КонецЦикла;
	КонецЕсли;

	Возврат НаборПараметров;
КонецФункции // ПараметрыОтчетовXUnit()

Процедура ОбеспечитьСуществованиеРодительскихКаталоговДляПутей(Знач НаборПараметров)
	ЕстьОшибка = Ложь;
	СообщениеОшибки = "Генерация отчетов тестирования невозможна, т.к. не существуют каталоги:";
	Для каждого КлючЗначение Из НаборПараметров Цикл
		Путь = КлючЗначение.Значение;
		Файл = Новый Файл(Путь);
		ОбъектКаталог = Новый Файл(Файл.Путь);

		ФС.ОбеспечитьКаталог(ОбъектКаталог.ПолноеИмя);

		Если Не ОбъектКаталог.Существует() Тогда
			ЕстьОшибка = Истина;
			СообщениеОшибки = СтрШаблон("%1	%2", СообщениеОшибки, ОбъектКаталог.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	Если ЕстьОшибка Тогда
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;
КонецПроцедуры
