
Процедура	ОбновитьИнформацияМодуляИнтеграции(connection_info)
	ЭтаФорма.СпособПодключения	= "Обработка";
	ЭтаФорма.ИнфоСистема		= get_prop(connection_info, "service", "");
	ЭтаФорма.ИнфоПодсистема		= get_prop(connection_info, "subsystem", "");
	ЭтаФорма.ИнфоВерсия			= get_prop(connection_info, "version", "");
КонецПроцедуры
