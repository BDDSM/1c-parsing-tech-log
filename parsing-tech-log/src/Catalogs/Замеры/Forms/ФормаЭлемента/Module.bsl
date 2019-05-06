#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ПолныйПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Д = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Д.Каталог = Объект.ПолныйПуть;
	Д.Показать(Новый ОписаниеОповещения("ПолныйПутьВыбор", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура СостояниеРЗНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(НастройкиРЗ) <> Тип("РасписаниеРегламентногоЗадания") Тогда
		НастройкиРЗ = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ИзменитьРегламентноеЗаданиеЗавершение", ЭтотОбъект);
	
	РедактированиеРасписания = Новый ДиалогРасписанияРегламентногоЗадания(НастройкиРЗ);
	РедактированиеРасписания.Показать(Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРегламентноеЗаданиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиРЗ = Расписание;
	СостояниеРЗ = Строка(Расписание);
	Если ЗагружатьАвтоматически = Ложь Тогда
		ЗагружатьАвтоматически = Истина;
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьАвтоматическиПриИзменении(Элемент)
	Если ЗагружатьАвтоматически 
		И НастройкиРЗ = Неопределено Тогда
			СостояниеРЗНажатие(Неопределено, Неопределено);
	ИначеЕсли НЕ ЗагружатьАвтоматически 
		И НастройкиРЗ <> Неопределено Тогда
		НастройкиРЗ = Неопределено;
		УстановитьПредставлениеСостоянияРЗ(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеРЗ()
	НастройкиРЗ = Неопределено;
	ЗагружатьАвтоматически = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если (Объект.ИдентификаторРЗ <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")) Тогда
			РЗ = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Объект.ИдентификаторРЗ);
			Если РЗ<>Неопределено 
				И РЗ.Использование Тогда
				ЗагружатьАвтоматически = Истина;					
				НастройкиРЗ = РЗ.Расписание;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	УстановитьПредставлениеСостоянияРЗ(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеСостоянияРЗ(Форма)
	Форма.СостояниеРЗ = ?(Форма.ЗагружатьАвтоматически, Строка(Форма.НастройкиРЗ), "<Отключено>");
КонецПроцедуры

&НаКлиенте
Процедура ПолныйПутьВыбор(Результат, Параметры) Экспорт
	Если Результат <> Неопределено И Результат.Количество() Тогда
		Объект.ПолныйПуть = Результат[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипЗамераПриИзменении(Элемент)
	Если Объект.ТипЗамера=ПредопределенноеЗначение("Перечисление.ТипыЗамеров.Произвольный") Тогда
		Элементы.ДополнительнаяОбработка.Видимость = Истина;
	Иначе
		Элементы.ДополнительнаяОбработка.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТипЗамераПриИзменении(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПриСозданииЧтенииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	УстановитьСостояниеРЗ();
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФильтрТипПроцесса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ФильтрТипПроцесса").Получить();
		ФильтрТипСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ФильтрТипСобытия").Получить();
	КонецЕсли;
	УстановитьЗаголовокФильтров(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрСвойсваСобытияПриИзменении(Элемент)
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьСостояниеРЗ();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЗагружатьАвтоматически", ЗагружатьАвтоматически);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("НастройкиРЗ", НастройкиРЗ);
	ТекущийОбъект.ФильтрТипПроцесса = Новый ХранилищеЗначения(ФильтрТипПроцесса);
	ТекущийОбъект.ФильтрТипСобытия = Новый ХранилищеЗначения(ФильтрТипСобытия);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФильтров(Форма)
	СписокФильтров = "";
	Если ЗначениеЗаполнено(Форма.Объект.НачалоПериода) ИЛИ ЗначениеЗаполнено(Форма.Объект.КонецПериода) Тогда
		 СписокФильтров = СписокФильтров + ?(СписокФильтров = "", "", "; ") + "Период";
	КонецЕсли;
	Если Форма.ФильтрТипПроцесса.Количество() Тогда
		 СписокФильтров = СписокФильтров + ?(СписокФильтров = "", "", "; ") + "Процессы";
	КонецЕсли;
	Если Форма.ФильтрТипСобытия.Количество() Тогда
		 СписокФильтров = СписокФильтров + ?(СписокФильтров = "", "", "; ") + "События";
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.Объект.ФильтрСвойстваСобытия) Тогда
		 СписокФильтров = СписокФильтров + ?(СписокФильтров = "", "", "; ") + "Свойства";
	КонецЕсли;
	Если ЗначениеЗаполнено(Форма.Объект.ФильтрДлительность) Тогда
		 СписокФильтров = СписокФильтров + ?(СписокФильтров = "", "", "; ") + "Длительность";
	КонецЕсли;
	Если СписокФильтров = "" Тогда
		СписокФильтров = "не установлены";
	КонецЕсли;
	Форма.Элементы.ГруппаФильтры.Заголовок = СтрШаблон("Фильтр (%1)", СписокФильтров);
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТипПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Спс = ПолучитьСписокСПометками("Процессы", ФильтрТипПроцесса);
	Спс.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ФильтрВыборЗавершение", ЭтотОбъект, ФильтрТипПроцесса));
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТипСобытияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Спс = ПолучитьСписокСПометками("События", ФильтрТипСобытия);
	Спс.ПоказатьОтметкуЭлементов(Новый ОписаниеОповещения("ФильтрВыборЗавершение", ЭтотОбъект, ФильтрТипСобытия));
КонецПроцедуры

&НаКлиенте
Процедура ФильтрВыборЗавершение(Результат, Параметры) Экспорт
	Если Результат<>Неопределено Тогда
		ЗаполнитьСписокПоОтметкам(Результат, Параметры);
		Модифицированность = Истина;
		НачатьУстановкуЗаголовкаФильтров();	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистить(Команда)
	Объект.НачалоПериода = Неопределено;
	Объект.КонецПериода = Неопределено;
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗамер(Команда)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОчиститьЗамерСервер(Объект.Ссылка);
		ПоказатьПредупреждение(,"Готово");
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьЗамерСервер(Ссылка)
	ОбновлениеДанныхРегламентное.ВыполнитьОчисткуПоНастройке(Новый Структура("Ссылка,ГлубинаХранения", Ссылка, -1), Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокПоОтметкам(Результат, Параметры);
	Параметры.Очистить();
	Для Каждого эл из Результат Цикл
		Если эл.Пометка Тогда
			Параметры.Добавить(эл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокСПометками(ИмяСправочника, Фильтр)
	Результат = Новый СписокЗначений();
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка КАК Ссылка ИЗ Справочник." + ИмяСправочника + " ГДЕ НЕ ПометкаУдаления УПОРЯДОЧИТЬ ПО Наименование");
	Результат.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	Для Каждого эл из Фильтр Цикл
		элрезультата = Результат.НайтиПоЗначению(эл.Значение);
		Если элрезультата<>Неопределено Тогда
			элрезультата.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ФильтрТипПроцессаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФильтрТипПроцесса.Очистить();
	Модифицированность = Истина;
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТипСобытияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФильтрТипСобытия.Очистить();
	Модифицированность = Истина;
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуЗаголовкаФильтров()
	ПодключитьОбработчикОжидания("ВыполнитьУстановкуЗаголовкаФильтров", 0.1, Истина);
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьУстановкуЗаголовкаФильтров() Экспорт
	УстановитьЗаголовокФильтров(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ФильтрДлительностьПриИзменении(Элемент)
	НачатьУстановкуЗаголовкаФильтров();
КонецПроцедуры



#КонецОбласти





