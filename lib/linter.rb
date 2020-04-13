module Linter
  class Parameters
    attr_reader :indentation, :code_length, :line_length, :i

    def initialize(file)
      @doc = file
      @indentation = 2 # Amount of spaces for indentation
      @code_length = 120 # Max length of code allowed in a single rb file
      @line_length = 80 # Max length in characters for a single line
    end
  end

  class Check < Parameters
    def code_length
      i = 0
      broken_rule = false
      File.readlines(@doc).each do
        i += 1
      end
      if i > @code_length
        broken_rule = true
        puts "More than #{@code_length} lines is not allowed."
      end
      broken_rule
    end

    def extra_space
      i = 0
      broken_rule = false
      File.readlines(@doc).each do |line|
        i += 1
        spaces_count = line.count(' ') - line.rstrip.count(' ')
        if spaces_count > @indentation
          broken_rule = true
          puts "You have extra spaces at the end of the line: " + i.to_s
        end
      end
      broken_rule
    end

    def empty_line
      i = 0
      empty_lines = []
      broken_rule = false
      File.readlines(@doc).each do |line|
        i += 1
        if line.gsub("\n","").length == 0
          empty_lines.push(i)
        end
      end
      (empty_lines.length - 1).times  do |x|
        if empty_lines[x + 1] - empty_lines[x] == 1
          broken_rule = true
          puts "You have more than one empty line: " + empty_lines[x].to_s
        end
      end
      broken_rule
    end

    def line_length
      broken_rule = false
      i = 0
      File.readlines(@doc).each do |line|
        i += 1
        if line.to_s.size > @line_length
          broken_rule = true
          puts "More than #{@line_length} characters per line is not allowed. Line: " + i.to_s
        end
      end
      broken_rule
    end

    def comparison_operator
      broken_rule = false
      i = 0
      File.readlines(@doc).each do |line|
        i += 1
        alternative_operator = " "
        response = "Change operator on line #{i.to_s}, use "
        if line.include? " != "
          broken_rule = true
          alternative_operator = "'!' instead."
          puts response + alternative_operator
        elsif line.include? " == "
          broken_rule = true
          alternative_operator = "'equal? or include?' instead."
          puts response + alternative_operator
        end
      end
      broken_rule
    end

    def logical_operator
      broken_rule = false
      i = 0
      File.readlines(@doc).each do |line|
        i += 1
        alternative_operator = " "
        response = "Change operator on line #{i.to_s}, use "
        if line.include? " and "
          broken_rule = true
          alternative_operator = "'&&' instead."
          puts response + alternative_operator
        elsif line.include? " or "
          broken_rule = true
          alternative_operator = "'||' instead."
          puts response + alternative_operator
        end
      end
      broken_rule
    end

    def current_file
      name = File.basename(@doc)
      print "Checking any broken rules in file: " + name
    end
  end
end
