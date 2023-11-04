#
# Author: Aidan Kiser (ark0053)
# Version: 3 November 2023
#

class AST
  # attr_accessor :down
  # attr_accessor :right
  # attr_accessor :token

   def initialize(tok)
      @token = tok
      @down = nil
      @right = nil
   end

   def get_token()
      return @token
   end

   def set_token(x)
      @token = x
   end

   def addChild(node)
      if (node == nil) then return nil end
      t = @down
      if (t != nil)
         while (t.getNextSibling() != nil)
            t = t.getNextSibling()
         end
         t.setNextSibling(node)
      else
         self.setFirstChild(node) 
      end
   end  

   def addAsFirstChild(node)
      if (node == nil) then return nil end
      t = @down
      if (t != nil)
         node.setNextSibling(t)
      end
      self.setFirstChild(node)
   end


   def getFirstChild
      return @down
   end

   def setFirstChild(c)
      @down = c
   end

   def getNextSibling
      return @right
   end

   def setNextSibling(n)
      @right = n
   end

   def to_s
      return @token.to_s    
   end

   def toStringList
      t = self
      ts = ""
      if (t.getFirstChild() != nil)then ts += " (" end
      ts += " #{self.to_s()}"
      if (t.getFirstChild() != nil)
         ts += t.getFirstChild().toStringList()
      end
      if (t.getFirstChild() != nil)then  ts += " )" end
      if (t.getNextSibling() != nil)
         ts += t.getNextSibling().toStringList()
      end
      return ts
   end
end