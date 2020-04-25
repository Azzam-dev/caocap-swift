//
//  Parser.swift
//  swift compiler
//
//  Created by Azzam AL-Rashed on 11/12/2019.
//  Copyright © 2019 ficruty. All rights reserved.
//

import Foundation

class Node {
    //TODO: pass
}

class Statement: Node {
    //TODO: pass
}

//TODO: can BlockStatement inherit from statement rather than node? Yes
class BlockStatement: Statement {
    //TODO: pass
}

class Expression {
    //TODO: pass
}

class VarStatement: Statement {
    //statement: var datatype id = expression | var int myAge = 19 + 1
    var token: Token
    var datatype: Token
    var identifier: Token
    var expression: Expression
    init(token: Token, datatype: Token, identifier: Token, expression: Expression) {
        self.token = token
        self.datatype = datatype
        self.identifier = identifier
        self.expression = expression
    }
}

//(this is not a constent statment.....its not like swift)
class LetStatement: Statement {
    //statement: let id = expression | let myAge = myAge + 1
    var token: Token
    var identifier: Token
    var expression: Expression
    init(token: Token, identifier: Token, expression: Expression) {
        self.token = token
        self.identifier = identifier
        self.expression = expression
    }
}

class PrintStatement: Statement {
    //statement: print expression | print 405
    var token: Token
    var expression: Expression
    init(token: Token, expression: Expression) {
        self.token = token
        self.expression = expression
    }
}

class WhileStatement: BlockStatement {
    //statement: while expression {statements} | while is_online { print online_time }
    var token: Token
    var expression: Expression
    var statements: [Statement]
    init(token: Token, expression: Expression, statements: [Statement]) {
        self.token = token
        self.expression = expression
        self.statements = statements
    }
}

class IfStatement: BlockStatement {
    //statement: if expression {statements} | if is_online { print user_name }
    var token: Token
    var expression: Expression
    var statements: [Statement]
    init(token: Token, expression: Expression, statements: [Statement]) {
        self.token = token
        self.expression = expression
        self.statements = statements
    }
}

class BinaryExpression: Expression {
    //Expression: left_exp theOperator right_exp | 10 + myAge
    var left_exp: Expression
    var theOperator: Token
    var right_exp: Expression
    init(left_exp:Expression,theOperator:Token,right_exp:Expression) {
        self.left_exp = left_exp
        self.theOperator = theOperator
        self.right_exp = right_exp
    }
}

class UnaryExpression: Expression {
    //Expression:  theOperator expression | !true
    var theOperator: Token
    var expression: Expression
    init(theOperator:Token,expression:Expression) {
        self.theOperator = theOperator
        self.expression = expression
    }
}

class LiteralExpression: Expression {
    //Expression: expression | 10
    var expression: Token
    init(expression:Token) {
        self.expression = expression
    }
}

class IdentifierExpression: Expression {
    //Expression: expression | myAge
    var expression: Token
    init(expression:Token) {
        self.expression = expression
    }
}

class GroupingExpression: Expression {
    //Expression: expression | ( 10 + myAge - 1 / 3 )
    var expression: Expression
    init(expression:Expression) {
        self.expression = expression
    }
}

class Parser {
    var tokenizer: Tokenizer
    var current_token: Token? = nil
    var next_token: Token? = nil
    var current_level = 0
    var is_first_token = true
    
    init(tokenizer: Tokenizer) {
        self.tokenizer = tokenizer
    }
    
    //git the next token and
    func consume() {
        if self.is_first_token {
            self.current_token = self.tokenizer.tokenize()
            self.is_first_token = false
        } else {
            self.current_token = self.next_token
        }
        self.next_token = self.tokenizer.tokenize()
    }
    
    func expression() -> Expression {
        self.consume()
        var expr = self.relational()
        while self.next_token!.value == "==" || self.next_token!.value == "!=" {
            self.consume()
            let theOperator = self.current_token!
            self.consume()
            let right_expr = self.relational()
            expr = BinaryExpression(left_exp: expr, theOperator: theOperator, right_exp: right_expr)
        }
        return expr
    }
    
    func relational() -> Expression {
        var expr = self.addition()
        while self.next_token!.value == ">" || self.next_token!.value == ">=" || self.next_token!.value == "<" || self.next_token!.value == "<=" {
            self.consume()
            let theOperator = self.current_token!
            self.consume()
            let right_expr = self.addition()
            expr = BinaryExpression(left_exp: expr, theOperator: theOperator, right_exp: right_expr)
        }
        return expr
    }
    
    func addition() -> Expression {
        var expr = self.term()
        while self.next_token!.value == "+" || self.next_token!.value == "-" {
            self.consume()
            let theOperator = self.current_token!
            self.consume()
            let right_expr = self.term()
            expr = BinaryExpression(left_exp: expr, theOperator: theOperator, right_exp: right_expr)
        }
        return expr
    }
    
    func term() -> Expression {
        var expr = self.factor()
        while self.next_token!.value == "*" || self.next_token!.value == "/" {
            self.consume()
            let theOperator = self.current_token!
            self.consume()
            let right_expr = self.factor()
            expr = BinaryExpression(left_exp: expr, theOperator: theOperator, right_exp: right_expr)
        }
        return expr
    }
    
    func factor() -> Expression {
        if self.current_token!.category == "literal" {
            return LiteralExpression(expression: self.current_token!)
        } else if self.current_token!.category == "identifier" {
            return IdentifierExpression(expression: self.current_token!)
        } else if self.current_token!.value == "(" {
            let result = GroupingExpression(expression: self.expression())
            self.match(token_value: ")")
            return result
        } else {
            //TODO: ask about this and if its okay to do it
            syntax_error(token: self.current_token!, message: "unexpected token")
            return LiteralExpression(expression: self.current_token!)
        }
    }
    
    func syntax_error(token: Token, message: String) {
        print("[Step(syntax error)]:" + message + ", " + "[\(token.value)]" + ", line number: " + String(token.line_number) + ", position: " + String(token.position))
    }
    
    func match(token_value: String) {
        self.consume()
        if self.current_token!.value != token_value {
            self.syntax_error(token: self.current_token!, message: "unexpected token")
        }
    }
    
    func var_parser() -> Statement {
        //follow this statement:  var datatype id = expression
        let var_token = self.current_token!
        self.consume()
        if !(self.current_token?.category == "keyword" && ["int", "float", "string", "boolean"].contains(self.current_token?.value)) {
            self.syntax_error(token: self.current_token!, message: "datatype expected")
        }
        let datatype_token = self.current_token!
        self.consume()
        if self.current_token?.category != "identifier" {
            self.syntax_error(token: self.current_token!, message: "identifier expected")
        }
        let identifier_token = self.current_token!
        self.match(token_value: "=")
        return VarStatement(token: var_token , datatype: datatype_token, identifier: identifier_token, expression: self.expression())
    }
    
    func let_parser() -> Statement {
        //follow this statement:  let id = expression | let myAge = myAge + 1
        let let_token = self.current_token!
        self.consume()
        if self.current_token?.category != "identifier" {
            self.syntax_error(token: self.current_token!, message: "identifier expected")
        }
        let identifier_token = self.current_token!
        self.match(token_value: "=")
        return LetStatement(token: let_token, identifier: identifier_token, expression: self.expression())
    }
    
    func print_parser() -> Statement {
        //follow this statement:  print expression | print myAge / 2
        return PrintStatement(token: self.current_token!, expression: self.expression())
    }
    
    func while_parser() -> Statement {
        //follow this statement:  while expression {statements} | while myAge < 100 { print is_alive }
        let while_token = self.current_token!
        let expression = self.expression()
        self.match(token_value: "{")
        self.current_level += 1
        let statements = self.parse()
        return WhileStatement(token: while_token, expression: expression, statements: statements)
    }
    
    func if_parser() -> Statement {
        //follow this statement:  if boolean {statements} | if is_alive { print myAge }
        let if_token = self.current_token!
        let expression = self.expression()
        self.match(token_value: "{")
        self.current_level += 1
        let statements = self.parse()
        return IfStatement(token: if_token, expression: expression, statements: statements)
    }
    
    func parse() -> [Statement] {
        var statements = [Statement]()
        self.consume()
        
        while self.current_token!.category != "EOF" {
            if self.current_token!.category == "keyword" {
                if self.current_token!.value == "var" {
                    statements.append(self.var_parser())
                } else if self.current_token!.value == "let" {
                    statements.append(self.let_parser())
                } else if self.current_token!.value == "print" {
                    statements.append(self.print_parser())
                } else if self.current_token!.value == "while" {
                    statements.append(self.while_parser())
                } else if self.current_token!.value == "if" {
                    statements.append(self.if_parser())
                }
            } else if self.current_token!.value == "}" {
                self.current_level -= 1
                return statements
            } else if self.current_token!.category == "comment" {
                //dont do any thing i.e skip ignore comment
            } else if self.current_token!.category == "whitespace"{
                //dont do any thing i.e skip ignore whitespace
            } else if self.current_token!.category == "error"{
               self.syntax_error(token: self.current_token!, message: "unexpected token")
            } else {
                self.syntax_error(token: self.current_token!, message: "unexpected token")
            }
            self.consume()
        }
        return statements
    }
    
    
}



