DECLARE @res INT, @status INT, @rr INT;
DECLARE @ResponseText TABLE (ResponseText NVARCHAR(MAX));
  
EXEC SP_OACREATE 'MSXML2.ServerXMLHTTP', @res OUT;
EXEC SP_OAMETHOD @res, 'open', NULL, 'GET', 'https://raw.githubusercontent.com/Mirshahreza/Zync/main/Packages/Elsa/ElsaWorkflowDefinitions.sql', 'false';
EXEC SP_OAMETHOD @res, 'send';
EXEC SP_OAGETPROPERTY @res, 'status', @status OUT;
INSERT INTO @ResponseText (ResponseText) EXEC SP_OAGETPROPERTY @res, 'responseText';
EXEC SP_OADESTROY @res;

SELECT TOP 20 SUBSTRING(ResponseText, 1, 500) AS FirstChars FROM @ResponseText;
