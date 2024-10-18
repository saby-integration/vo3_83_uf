
//DynamicDirective
Функция ПриСозданииНовогоПодключения(connection_info) Экспорт
	
	СчётОбъектов = 1;
	ПроцентПрогресса = 0;
	
	ВсегоОбъектов = connection_info["ExtSysSettings"].Количество();	
	
	Для каждого Элем из connection_info["ExtSysSettings"] Цикл
		ПроцентПргресса = Окр(СчётОбъектов / ВсегоОбъектов * 100, 0);
		ИмяОбъектаСинхронизации = Элем.Ключ;
		ИмяОбъектаСинхронизации = get_prop(Элем.Значение, "data", Элем.Ключ);
		ИмяОбъектаСинхронизации = get_prop(ИмяОбъектаСинхронизации, "КрасивоеНазвание", Элем.Ключ);
		ИмяОбъектаСинхронизации = get_prop(ИмяОбъектаСинхронизации, "Значение", Элем.Ключ);
		СчётОбъектов = СчётОбъектов + 1;
		
		ИмяИни = СтрЗаменить(Элем.Ключ, "Blockly_", "");
		Если Найти(ИмяИни, "predefine") > 0 Тогда
			Попытка
				ПараметрыВызова = Новый Структура("algorithm, object, endpoint, params, operation_uuid, connection_uuid", 
					ИмяИни, 
					Новый Структура("object", Неопределено), 
					Неопределено,
					Неопределено,
					Строка(Новый УникальныйИдентификатор()),
					connection_info["ConnectionId"]);
				result	= ПолучитьФормуBlockly().API_BLOCKLY_RUN(ПараметрыВызова);
				Если result["status"] = "complete" Тогда
					Если ТипЗнч(result["data"]) = Тип("Массив") Тогда 
						Для каждого _data из result["data"] Цикл
							Транспорт.local_helper_extsyncdoc_write_predefined(context["params"], context["operation"]["connection_uuid"], _data["Type"], _data["ClientType"], _data["Objects"]);	
						КонецЦикла;	
					Иначе	
						Транспорт.local_helper_extsyncdoc_write_predefined(context["params"], context["operation"]["connection_uuid"], result["data"]["Type"], result["data"]["ClientType"], result["data"]["Objects"]);  
					КонецЕсли;  
				ИначеЕсли result["status"] = "error" Тогда
					ВызватьИсключение NewExtExceptionСтрока(,"Не удалость загрузить предопределенные данные - " + ИмяИни, "command_processpredefineobject");	
				КонецЕсли;	
			Исключение
				ИнфОбОшибке = ИнформацияОбОшибке();
				ВызватьИсключение(NewExtExceptionСтрока(ИнфОбОшибке, "Объект не содержит необходимый параметр"));
			КонецПопытки;
		КонецЕсли;	
	КонецЦикла;	
	ПроцентПрогресса = 100;
КонецФункции
