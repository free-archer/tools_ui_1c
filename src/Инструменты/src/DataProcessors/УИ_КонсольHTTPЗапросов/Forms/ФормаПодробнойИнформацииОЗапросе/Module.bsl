
#Область ОбработчикиСобытийФормы

// Код процедур и функций


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//@skip-check unknown-form-parameter-access
	СтрокаЗапроса = Параметры.СтрокаЗапроса;
	//@skip-check unknown-form-parameter-access
	СтрокаИстории = Параметры.СтрокаИстории;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекСтрокаЗапроса = ВладелецФормы.ДеревоЗапросов.НайтиПоИдентификатору(СтрокаЗапроса);
	Если ТекСтрокаЗапроса = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекСтрокаИстории = ТекСтрокаЗапроса.ИсторияЗапросов.НайтиПоИдентификатору(СтрокаИстории);
	Если ТекСтрокаИстории = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТекСтрокаИстории);
	Если ЭтоАдресВременногоХранилища(АдресТелаОтветаСтрокой) Тогда
		ТелоОтветаСтрока = ПолучитьИзВременногоХранилища(АдресТелаОтветаСтрокой);
	КонецЕсли;
	
	ЗаголовокНастройкиПроксиАнализаЗапроса = ЗаголовокНастроекПроксиПоПараметрам();

	Заголовок = "" + Дата + "," + HTTPФункция + "," + URLЗапроса;

	Если ВидТелаЗапроса = "Строка" Тогда
		ТекСтраница = Элементы.ГруппаИсторияЗапросовТелоЗапросаСтраницаСтрока;
	ИначеЕсли ВидТелаЗапроса = "ДвоичныеДанные" Тогда
		ТекСтраница = Элементы.ГруппаИсторияЗапросовТелоЗапросаСтраницаДвоичныеДанные;
	Иначе
		ТекСтраница = Элементы.ГруппаИсторияЗапросовТелоЗапросаСтраницаФайл;
	КонецЕсли;
	Элементы.ГруппаИсторияЗапросовТелоЗапросаСтраницы.ТекущаяСтраница = ТекСтраница;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы


&НаКлиенте
Процедура РедактироватьТелоОтветаВРедактореJSONАнализируемогоЗапроса(Команда)
	УИ_ОбщегоНазначенияКлиент.РедактироватьJSON(ТелоОтветаСтрока, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТелоОтветаДвоичныеДанныеВФайл(Команда)
	Если Не ЭтоАдресВременногоХранилища(ТелоОтветаАдресДвоичныхДанных) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыСохранения = УИ_ОбщегоНазначенияКлиент.НовыйПараметрыСохраненияФайла();
	ПараметрыСохранения.АдресФайлаВоВременномХранилище = ТелоОтветаАдресДвоичныхДанных;

	УИ_ОбщегоНазначенияКлиент.НачатьСохранениеФайла(ПараметрыСохранения);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьТелоЗапросаВРедактореJSONАнализируемогоЗапроса(Команда)
	УИ_ОбщегоНазначенияКлиент.РедактироватьJSON(ТелоЗапросаСтрока, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДвоичныеДанныеТелаЗапросаИзИстории(Команда)
	Если Не ЭтоАдресВременногоХранилища(ТелоЗапросаАдресДвоичныхДанных) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыСохранения = УИ_ОбщегоНазначенияКлиент.НовыйПараметрыСохраненияФайла();
	ПараметрыСохранения.АдресФайлаВоВременномХранилище = ТелоЗапросаАдресДвоичныхДанных;

	УИ_ОбщегоНазначенияКлиент.НачатьСохранениеФайла(ПараметрыСохранения);
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗаголовокНастроекПроксиПоПараметрам()
	ПрефиксЗаголовка = "";

	Если ИспользоватьПрокси Тогда
		ЗаголовокГруппыПрокси = ПрефиксЗаголовка + ПроксиСервер;
		Если ЗначениеЗаполнено(ПроксиПорт) Тогда
			ЗаголовокГруппыПрокси = ЗаголовокГруппыПрокси + ":" + Формат(ПроксиПорт, "ЧГ=0;");
		КонецЕсли;

		Если ПроксиАутентификацияОС Тогда
			ЗаголовокГруппыПрокси = ЗаголовокГруппыПрокси + "; Аутентификация ОС";
		ИначеЕсли ЗначениеЗаполнено(ПроксиПользователь) Тогда
			ЗаголовокГруппыПрокси = ЗаголовокГруппыПрокси + ";" + ПроксиПользователь;
		КонецЕсли;

	Иначе
		ЗаголовокГруппыПрокси = ПрефиксЗаголовка + " Не используется";
	КонецЕсли;

	Возврат ЗаголовокГруппыПрокси;
КонецФункции

#КонецОбласти
