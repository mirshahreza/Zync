-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2026-01-08
-- Author:      Mohsen Mirshahreza
-- Description: Simple seed data - 3 records only
-- =============================================

TRUNCATE TABLE BaseUsers; 
TRUNCATE TABLE BaseRoles; 
TRUNCATE TABLE BaseInfo; 
TRUNCATE TABLE BasePersons; 

-- Password: 'P@ssw0rd' (you should change this after first login)
INSERT INTO BaseUsers (CreatedBy, CreatedOn, IsBuiltIn, UserName, Email, Password, PasswordUpdatedBy, PasswordUpdatedOn, IsActive, LoginLocked, LoginTryFailsCount)
VALUES (0, GETDATE(), 1, 'admin', 'admin@system.local', '161EBD7D45089B3446EE4E0D86DBCF92', 0, GETDATE(), 1, 0, 0);
DECLARE @ActorId INT = (SELECT TOP 1 Id FROM BaseUsers);
UPDATE BaseUsers SET CreatedBy=@ActorId;

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (@ActorId, GETDATE(), 'Developer', 1, 'Full access', 1);

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (@ActorId, GETDATE(), 'BackOfficer', 1, 'Admin access', 1);

INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  NULL,   '100',  'Gender',   'Gender',   N'جنسيت',   N'جنس'  );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '100',  '100.1','Male',     'Male',     N'مرد',     N'ذکر'  );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '100',  '100.2','Female',   'Female',   N'زن',      N'انثی' );


INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  NULL,   '101',  'EntityType',  'Person Type',  N'نوع شخصيت',   N'نوع الشخصية'      );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '101',  '101.1','Indivisual',  'Indivisual',   N'حقيقي',       N'الشخصية الحقيقية' );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '101',  '101.2','Company',     'Company',      N'حقوقي',       N'الشخصية الاعتبارية');


INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  NULL,   '102',  'RecordState',  'Record State',N'وضعيت رکورد',  N'حالة السجل'   );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '102',   '102.1','Active',      'Active',      N'فعال',         N'نشيط'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '102',   '102.2','UnderReview', 'Under Review',N'درحال بررسي',  N'قيد المراجعة' );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, GETDATE(),  '102',   '102.3','Rejected',    'Rejected',    N'رد شده',       N'مرفوضة'        );

INSERT INTO BasePersons (CreatedBy,CreatedOn,GenderId,EntityTypeId,RecordStateId,FirstName,LastName,Mobile,UserId) VALUES (@ActorId,GETDATE(),'100.1','101.1','102.1',N'Admin', N'Admin', '09121234567',@ActorId);




