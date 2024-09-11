// TODO все обработчики событий убрать из core
&НаСервере
Функция ПриОбновленииМодуля(НазваниеПродукта, ВерсияПродукта, ОбщиеНастройки)

	ИнициализацияОбщихНастроекБД(ОбщиеНастройки);
	//Заполним справочник состояний объектов
	//Справочники.Saby_СостоянияОбъектов.НачальнаяИнициализация();
	//Создадим ДопСведение - "КЭДО"
	//СоздатьДополнительноеСвойствоКЭДО();

	Возврат ОбщиеНастройки;
КонецФункции 

Функция ПолучитьПубличныеНастройкиПоУмолчанию() Экспорт
	ПубличныеОбщиеНастройки	= Новый Структура();
	ПубличныеОбщиеНастройки.Вставить("download_attachments_on_complete",		Истина);
	ПубличныеОбщиеНастройки.Вставить("download_attachments_on_update",			Истина);
	ПубличныеОбщиеНастройки.Вставить("refresh_statuses",						Ложь);
	ПубличныеОбщиеНастройки.Вставить("run_docflow",								Истина);
	ПубличныеОбщиеНастройки.Вставить("send_invitations",						Истина);
	ПубличныеОбщиеНастройки.Вставить("send_completed_documents",				Истина);
	ПубличныеОбщиеНастройки.Вставить("pdf_attachments",							Ложь);
	Возврат ПубличныеОбщиеНастройки;
КонецФункции

Функция ИнициализацияОбщихНастроекБД(ОбщиеНастройки)
	Если ТипЗнч(ОбщиеНастройки) <> Тип("Структура") Тогда
		ОбщиеНастройки = Новый Структура();
	КонецЕсли;
	
	ПубличныеОбщиеНастройки = get_prop(ОбщиеНастройки, "public", Новый Структура);
	ПубличныеНастройкиПоУмолчанию = ПолучитьПубличныеНастройкиПоУмолчанию();
	//Обновим список настроек новыми параметрами если они появились в новой версии расширения
	//или заполним значениями по умолчанию в лучае их отсутствия у пользоваетеля
	Для Каждого КлючЗначениеПараметра Из ПубличныеНастройкиПоУмолчанию Цикл
		Если get_prop(ПубличныеОбщиеНастройки, КлючЗначениеПараметра.Ключ) = Неопределено Тогда
			ПубличныеОбщиеНастройки.Вставить(КлючЗначениеПараметра.Ключ, КлючЗначениеПараметра.Значение);
		КонецЕсли;
	КонецЦикла;
	ОбщиеНастройки.Вставить("public", ПубличныеОбщиеНастройки);
	
	//Заполним	версию расширения, для проверки обновления
	ВерсияРасширения	= "0.0.0";
	Если НЕ ОбщиеНастройки.Свойство("ВерсияРасширения", ВерсияРасширения) Тогда
		ВерсияРасширения	= "0.0.0";
		ОбщиеНастройки.Вставить("ВерсияРасширения", ВерсияРасширения);
	КонецЕсли;
КонецФункции

Процедура СоздатьДополнительноеСвойствоКЭДО()
	ИмяСвойства	= "КЭДО";
	УстановитьПривилегированныйРежим(Истина);
	НайденноеСвойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию( ИмяСвойства, Истина );
	Если НЕ ЗначениеЗаполнено(НайденноеСвойство) Тогда
		//
		НовПВХ = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
		ТипСвойства			= Новый ОписаниеТипов("Булево");
		НовПВХ.Наименование	= ИмяСвойства;
		НовПВХ.Заголовок	= ИмяСвойства;
		НовПВХ.Имя			= ИмяСвойства;
		НовПВХ.ТипЗначения	= ТипСвойства;
        НовПВХ.ЭтоДополнительноеСведение = Истина;        
        НовПВХ.Записать();
		НайденноеСвойство	= НовПВХ.Ссылка;
	КонецЕсли;
	
	//Теперь настроим отображение этого элемента в справочнике сотрудников
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НДРС.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НДРС
		|ГДЕ
		|	НДРС.ИмяПредопределенногоНабора = ""Справочник_Сотрудники"" ";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	РазделИнтерфейса = Неопределено;
	Для Каждого СтрокаРЗ Из РезультатЗапроса Цикл
		РазделИнтерфейса = СтрокаРЗ.Ссылка;
	КонецЦикла;
	Если РазделИнтерфейса = Неопределено Тогда
		РазделИнтерфейса	= Справочники.НаборыДополнительныхРеквизитовИСведений.СоздатьЭлемент();
		РазделИнтерфейса.Наименование	= "Сотрудники";
		РазделИнтерфейса.Используется	= Истина;
		РазделИнтерфейса.ИмяПредопределенногоНабора	= "Справочник_Сотрудники";
		РазделИнтерфейса.Записать();
		РазделИнтерфейса = РазделИнтерфейса.Ссылка;
	КонецЕсли;
	РазделИнтерфейса	= РазделИнтерфейса.ПолучитьОбъект();
	мЭлементов = РазделИнтерфейса.ДополнительныеСведения.НайтиСтроки(Новый Структура("Свойство",НайденноеСвойство));
	Если мЭлементов.Количество() = 0 Тогда
		СтрокаДопСведений = РазделИнтерфейса.ДополнительныеСведения.Добавить();
		СтрокаДопСведений.Свойство						= НайденноеСвойство;
		СтрокаДопСведений.ПометкаУдаления				= Ложь;
		СтрокаДопСведений.ИмяПредопределенногоНабора	= "Справочник_Сотрудники";
	КонецЕсли;
	РазделИнтерфейса.КоличествоСведений	= РазделИнтерфейса.ДополнительныеСведения.Количество();
	РазделИнтерфейса.Записать();
КонецПроцедуры

