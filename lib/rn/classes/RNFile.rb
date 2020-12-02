module RN
   class RNFile

      include FileUtils
      include Paths

      attr_accessor :title, :path

      def initialize title, path
         @title = title
         @path = path
      end

      def to_s
         name
      end
   end
end