WHILE X <= @@ROWCOUNT
X++
@postAPexchangeRate = select exchangeRate from postap where id = X
@auditnumber = select cauditnumber from postap where id = X
@postGLexchangeRate = select exchangeRate from postgl where cauditnumber = @auditnumber

IF @postAPexchangeRate == @postGLexchangeRate
	CONTINUE;
ELSE
	@LIST = @LIST.append(@auditnumber)

PRINT @LIST