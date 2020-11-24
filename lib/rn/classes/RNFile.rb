module RN
   class RNFile

      include FileOperations
      include Paths

      ABSTRACT_ERROR = "Calling abstract method, should be defined in subclass"

      attr_accessor :title, :path

      def initialize title, path
         @title = title
         @path = path
      end

      def to_s
         @title
      end

      def delete
         raise ABSTRACT_ERROR
      end
   end
end