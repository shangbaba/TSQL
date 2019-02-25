-- Store image in database
SELECT * FROM OPENROWSET(BULK 'C:\Image.jpg', SINGLE_BLOB i)