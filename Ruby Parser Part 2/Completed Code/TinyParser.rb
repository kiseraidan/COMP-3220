#
# Author: Aidan Kiser (ark0053)
# Version: 3 November 2023
#

#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
    	@errors_found = 0
		
		p = AST.new(Token.new("program","program"))
		
	    while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
      
		return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        t = term()

        if (@lookahead.type == Token::ADDOP || @lookahead.type == Token::SUBOP)
            operator = etail()
            operator.addAsFirstChild(t)
            return operator
        end
        return t
    end

    def term()
        f = factor()
        if (@lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP)
            operator = ttail()
            operator.addAsFirstChild(f)
            return operator
        end
        return f
    end

    def factor()
        fct = AST.new(Token.new("factor","factor"))
        if (@lookahead.type == Token::LPAREN)
            match(Token::LPAREN)
            fct = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            fct = AST.new(@lookahead)
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            fct = AST.new(@lookahead)
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end
		return fct
    end

    def ttail()
        tt = AST.new(Token.new("ttail","ttail"))
        if (@lookahead.type == Token::MULTOP)
            tt = AST.new(@lookahead)
            match(Token::MULTOP)
            tt.addChild(factor())

            t_res = ttail()
            if t_res != nil
                tt.addChild(t_res)
            end
        elsif (@lookahead.type == Token::DIVOP)
            tt = AST.new(@lookahead)
            match(Token::DIVOP)
            tt.addChild(factor())

            t_res = ttail()
            if t_res != nil
                tt.addChild(t_res)
            end
		else
            tt = nil
        end
        return tt
    end

    def etail()
        et = AST.new(Token.new("etail","etail"))
        if (@lookahead.type == Token::ADDOP)
            et = AST.new(@lookahead)
            match(Token::ADDOP)
            et.addChild(term())

            e_res = etail()
            if e_res != nil
                et.addChild(e_res)
            end
        elsif (@lookahead.type == Token::SUBOP)
            et = AST.new(@lookahead)
            match(Token::SUBOP)
            et.addChild(term())

            e_res = etail()
            if e_res != nil
                et.addChild(e_res)
            end
		else
            et = nil
        end
        return et
    end

    def assign()
        assgn = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtok = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assgn = AST.new(@lookahead)
				assgn.addChild(idtok)
            	match(Token::ASSGN)
				assgn.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assgn
	end
end
