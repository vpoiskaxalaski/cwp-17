--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).
select tablespace_name, file_name from DBA_DATA_FILES;   --������ ������ 
select tablespace_name, file_name from DBA_TEMP_FILES;  --������ ������

--2. �������� ��������� ������������ � ������ XXX_QDATA (10m).
--��� �������� ���������� ��� � ��������� offline.
--����� ���������� ��������� ������������ � ��������� online. 
--�������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
DROP TABLESPACE SAM_QDATA INCLUDING CONTENTS AND DATAFILES;

create tablespace SAM_QDATA  
datafile 'sam_qdata_tablespace' size 10M
OFFLINE;

alter tablespace SAM_QDATA ONLINE;

CREATE USER C##SAM IDENTIFIED BY s12345678
DEFAULT TABLESPACE SAM_QDATA QUOTA 2M on SAM_QDATA;

ALTER USER C##SAM IDENTIFIED BY q12345678;
GRANT RESTRICTED SESSION, CREATE SESSION, RESOURCE, CREATE TABLESPACE TO C##SAM;
--������� � ������ "asSAM"

--3. �������� ������ ��������� ���������� ������������  XXX_QDATA.
--���������� ������� ������� XXX_T1.
--���������� ��������� ��������.

select * from dba_segments where tablespace_name = 'SAM_QDATA';
select * from dba_segments;

--asSAM

--�������� ������ ��������� ���������� ������������  XXX_QDATA.
--���������� �������� ���������� ������������ XXX_QDATA.
select * from dba_segments where tablespace_name = 'SAM_QDATA';

select * from dba_segments where tablespace_name = 'SAM_T1';
--asSAM

--7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������.
--�������� �������� ���� ���������.
select segment_name, extents, blocks, bytes from dba_segments where tablespace_name = 'SAM_QDATA';
select * from dba_extents;

--8. ������� ��������� ������������ XXX_QDATA � ��� ����. 
DROP TABLESPACE SAM_QDATA INCLUDING CONTENTS AND DATAFILES;

--9. �������� �������� ���� ����� �������� �������(�������� ���������).
-- ���������� ������� ������ �������� �������.
SELECT * FROM V$LOG;
SELECT GROUP# FROM V$LOG WHERE STATUS = 'CURRENT';

--10. �������� �������� ������ ���� �������� ������� ��������.
SELECT * FROM V$LOGFILE;

--11. � ������� ������������ �������� ������� �������� ������ ���� ������������.
--�������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).
ALTER SYSTEM SWITCH LOGFILE;

--12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������.
--��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������).
ALTER DATABASE ADD LOGFILE GROUP 4 'C:\APP\ADMID\ADMIN\ORCL\REDO04.LOG'
SIZE 150m BLOCKSIZE 512;

ALTER DATABASE ADD LOGFILE MEMBER'C:\APP\ADMID\ADMIN\ORCL\REDO04A.LOG' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER'C:\APP\ADMID\ADMIN\ORCL\REDO04B.LOG' TO GROUP 4;

ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$LOG;

--13. ������� ��������� ������ �������� �������. 
--������� ��������� ���� ����� �������� �� �������.

ALTER DATABASE DROP LOGFILE GROUP 4;

--14. ����������, ����������� ��� ��� ������������� �������� �������
--(������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).
--15. ���������� ����� ���������� ������.  
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--16. �������� �������������. 
shutdown IMMEDIATE;
STARTUP MOUNT;
alter database ARCHIVELOG;
--17. EX. ������������� �������� �������� ����.
--���������� ��� �����. 
--���������� ��� �������������� � ��������� � ��� �������.
--���������� ������������������ SCN � ������� � �������� �������. 
--(������������ ����� ������ ����� ������� � ���������� �������)
alter system switch logfile;
select * from v$archived_log;

--18. EX. ��������� �������������.
--���������, ��� ������������� ���������.  
SELECT * FROM V$LOG;
SELECT * FROM V$DATABASE;

--19. �������� ������ ����������� ������.
--(���������� ������������ ������ ��)
select * from v$controlfile;

--20. �������� � ���������� ���������� ������������ �����.
--�������� ��������� ��� ��������� � �����.
show parameter control;
select * from v$controlfile_record_section;

--21. ���������� �������������� ����� ���������� ��������.
--��������� � ������� ����� �����. 
--22. ����������� PFILE � ������ XXX_PFILE.ORA. 
--���������� ��� ����������.
create pfile = 'sam_pfile.ora.' from spfile;

--23. ���������� �������������� ����� ������� ��������.
--��������� � ������� ����� �����. 
select* from v$pwfile_users;

--24. �������� �������� ����������� ��� ������ ��������� � �����������. 
select * from v$diag_info;
--25. EX. ������� � ���������� ���������� ��������� ������ �������� (LOG.XML), 
--������� � ��� ������� ������������ �������� ������� �� ���������.