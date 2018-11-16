--1. Получите список всех файлов табличных пространств (перманентных  и временных).
select tablespace_name, file_name from DBA_DATA_FILES;   --перман данные 
select tablespace_name, file_name from DBA_TEMP_FILES;  --времен данные

--2. Создайте табличное пространство с именем XXX_QDATA (10m).
--При создании установите его в состояние offline.
--Затем переведите табличное пространство в состояние online. 
--Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
DROP TABLESPACE SAM_QDATA INCLUDING CONTENTS AND DATAFILES;

create tablespace SAM_QDATA  
datafile 'sam_qdata_tablespace' size 10M
OFFLINE;

alter tablespace SAM_QDATA ONLINE;

CREATE USER C##SAM IDENTIFIED BY s12345678
DEFAULT TABLESPACE SAM_QDATA QUOTA 2M on SAM_QDATA;

ALTER USER C##SAM IDENTIFIED BY q12345678;
GRANT RESTRICTED SESSION, CREATE SESSION, RESOURCE, CREATE TABLESPACE TO C##SAM;
--ПЕРЕЙТИ В СКРИВТ "asSAM"

--3. Получите список сегментов табличного пространства  XXX_QDATA.
--Определите сегмент таблицы XXX_T1.
--Определите остальные сегменты.

select * from dba_segments where tablespace_name = 'SAM_QDATA';
select * from dba_segments;

--asSAM

--Получите список сегментов табличного пространства  XXX_QDATA.
--Определите сегменты табличного пространства XXX_QDATA.
select * from dba_segments where tablespace_name = 'SAM_QDATA';

select * from dba_segments where tablespace_name = 'SAM_T1';
--asSAM

--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах.
--Получите перечень всех экстентов.
select segment_name, extents, blocks, bytes from dba_segments where tablespace_name = 'SAM_QDATA';
select * from dba_extents;

--8. Удалите табличное пространство XXX_QDATA и его файл. 
DROP TABLESPACE SAM_QDATA INCLUDING CONTENTS AND DATAFILES;

--9. Получите перечень всех групп журналов повтора(фиксация изменений).
-- Определите текущую группу журналов повтора.
SELECT * FROM V$LOG;
SELECT GROUP# FROM V$LOG WHERE STATUS = 'CURRENT';

--10. Получите перечень файлов всех журналов повтора инстанса.
SELECT * FROM V$LOGFILE;

--11. С помощью переключения журналов повтора пройдите полный цикл переключений.
--Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).
ALTER SYSTEM SWITCH LOGFILE;

--12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала.
--Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением).
ALTER DATABASE ADD LOGFILE GROUP 4 'C:\APP\ADMID\ADMIN\ORCL\REDO04.LOG'
SIZE 150m BLOCKSIZE 512;

ALTER DATABASE ADD LOGFILE MEMBER'C:\APP\ADMID\ADMIN\ORCL\REDO04A.LOG' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER'C:\APP\ADMID\ADMIN\ORCL\REDO04B.LOG' TO GROUP 4;

ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$LOG;

--13. Удалите созданную группу журналов повтора. 
--Удалите созданные вами файлы журналов на сервере.

ALTER DATABASE DROP LOGFILE GROUP 4;

--14. Определите, выполняется или нет архивирование журналов повтора
--(архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).
--15. Определите номер последнего архива.  
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--16. Включите архивирование. 
shutdown IMMEDIATE;
STARTUP MOUNT;
alter database ARCHIVELOG;
--17. EX. Принудительно создайте архивный файл.
--Определите его номер. 
--Определите его местоположение и убедитесь в его наличии.
--Проследите последовательность SCN в архивах и журналах повтора. 
--(расположение файла архива можно увидеть в результате селекта)
alter system switch logfile;
select * from v$archived_log;

--18. EX. Отключите архивирование.
--Убедитесь, что архивирование отключено.  
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--19. Получите список управляющих файлов.
--(физическое расположение файлов бд)
select * from v$controlfile;

--20. Получите и исследуйте содержимое управляющего файла.
--Поясните известные вам параметры в файле.
show parameter control;
select * from v$controlfile_record_section;

--21. Определите местоположение файла параметров инстанса.
--Убедитесь в наличии этого файла. 
--22. Сформируйте PFILE с именем XXX_PFILE.ORA. 
--Исследуйте его содержимое.
create pfile = 'sam_pfile.ora.' from spfile;

--23. Определите местоположение файла паролей инстанса.
--Убедитесь в наличии этого файла. 
select* from v$pwfile_users;

--24. Получите перечень директориев для файлов сообщений и диагностики. 
select * from v$diag_info;
--25. EX. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), 
--найдите в нем команды переключения журналов которые вы выполняли.