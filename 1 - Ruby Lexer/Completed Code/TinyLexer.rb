#
# Author: Aidan Kiser (ark0053)
# Version: 7 September 2023
#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer 
	# Constructor - Is passed a file to scan and outputs a token
	#               each time nextToken() is invoked.
	#   @c        - A one character lookahead 
		def initialize(filename)
			# Need to modify this code so that the program
			# doesn't abend if it can't open the file but rather
			# displays an informative message
			if (! File.exists?(filename))
				puts "File name does not exist. Exiting."
				return nil
			end
			@f = File.open(filename,'r:utf-8')
			
			# Go ahead and read in the first character in the source
			# code file (if there is one) so that you can begin
			# lexing the source code file 
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
				@f.close()
			end
	
			@ophash = {
				"+" => Token::ADDOP,
				"-" => Token::SUBOP,
				"/" => Token::DIVOP,
				"*" => Token::MULOP,
				"(" => Token::LPAREN,
				")" => Token::RPAREN,
				"=" => Token::EQUALSOP
			}
	
		end
		
		# Method nextCh() returns the next character in the file
		def nextCh()
			if (! @f.eof?)
				@c = @f.getc()
			else
				@c = "eof"
			end
			
			return @c
		end
	
		# Method nextToken() reads characters in the file and returns
		# the next token
		# You should also print what you find. Follow the format from the
		# example given in the instructions.
		def nextToken() 
			if @c == "eof"
				tok = Token.new(Token::EOF,"eof")
				printToken(tok)
				return tok
					
			elsif (whitespace?(@c))
				str =""
			
				while whitespace?(@c)
					str += @c
					nextCh()
				end
			
				tok = Token.new(Token::WS,str)
				printToken(tok)
				return tok
			elsif (numeric?(@c))
				num = ""
	
				while numeric?(@c)
					num += @c
					nextCh()
				end
				
				tok = Token.new(Token::INTNUM, num)
				printToken(tok)
				return tok
			
			elsif (letter?(@c))
				str = ""
	
				while letter?(@c)
					str += @c
					nextCh()
				end
				
				tok_type = Token::ID
				
				if str == "print"
					tok_type = Token::PRINT
				end
				
				tok = Token.new(tok_type, str)
				printToken(tok)
				return tok
				
			elsif (operator?(@c))
				token_type = @ophash[@c]
				tok = Token.new(token_type, @c)
				printToken(tok)
				nextCh()
				return tok
			# elsif ...
			# more code needed here! complete the code here 
			# so that your lexer can correctly recognize,
			# display and return all tokens
			# in our grammar that we found in the source code file
			
			# FYI: You don't HAVE to just stick to if statements
			# any type of selection statement "could" work. We just need
			# to be able to programatically identify tokens that we 
			# encounter in our source code file.
			
			# don't want to give back nil token!
			# remember to include some case to handle
			# unknown or unrecognized tokens.
			# below I make the token that you should pass back
			else
				tok = Token.new("unknown","unknown")
				printToken(tok)
				nextCh()
				return tok
			end
		end
	end
	#
	# Helper methods for Scanner
	#
	def printToken(tok)
		puts "Next token is: #{tok.type}, Next lexeme is: #{tok.text}"
	end
	# Added for operator recognition
	def operator?(lookAhead)
		lookAhead =~ /^[+-\/=*\(\)]$/
	end
	def letter?(lookAhead)
		lookAhead =~ /^[a-z]|[A-Z]$/
	end
	
	def numeric?(lookAhead)
		lookAhead =~ /^(\d)+$/
	end
	
	def whitespace?(lookAhead)
		lookAhead =~ /^(\s)+$/
	end