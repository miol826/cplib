#!/usr/bin/ruby
require 'open3'
require 'optparse'
require 'io/console/size'

def main
  options = get_options

  num_test = options[:N]
  testcase_input_filename = options[:testcase_input].freeze
  testcase_output_filename1 = options[:testcase_output1].freeze
  testcase_output_filename2 = options[:testcase_output2].freeze
  max_length = options[:max_length]
  input_generator = options[:input_generator].freeze
  cmd1 = options[:command1].freeze
  cmd2 = options[:command2].freeze
  num_threads = options[:threads]

  refresh_progress_bar 0, num_test
  finished_test_counter = 0

  threads = (0...num_threads).map do |i|
    Thread.new do
      thread_num_test = num_test / num_threads + (i % num_threads < num_test % num_threads ? 1 : 0)

      thread_num_test.times do
        testcase = generate_testcase input_generator

        out1 = run_cmd cmd1, testcase, testcase_input_filename, testcase_output_filename1, max_length
        if !cmd2.nil? then
          out2 = run_cmd cmd2, testcase, testcase_input_filename, testcase_output_filename2, max_length
          compare_output cmd1, cmd2, out1, out2, testcase, testcase_input_filename, testcase_output_filename1, testcase_output_filename2, max_length
        end

        finished_test_counter += 1
        refresh_progress_bar finished_test_counter, num_test
      end
    end
  end
  threads.each &:join

  puts
end

def refresh_progress_bar(numerator, denomnator)
  colsize = IO.console_size[1]
  ratio = numerator.fdiv(denomnator)

  snum = (numerator == denomnator ? colsize - 2 : (ratio * (colsize - 2)).to_i.clamp(0, colsize - 3))

  str = '[' + '#' * snum + ' ' * (colsize - 2 - snum) + ']'
  strp = sprintf "(%5.1f %%)", ratio * 100

  d = (str.size - strp.size) / 2
  (0...strp.size).each do |i|
    str[d + i] = strp[i]
  end
  print "\r" + str
end

def get_options
  res = {:N => 10, :max_length => 100, :threads => 8}

  OptionParser.new do |opt|
    opt.banner = "Usage: test.rb [options] input_generator command1 [command2]"
    opt.on("-N VALUE", Integer, "repeat number of test") {|v| res[:N] = v}
    opt.on("-i FILENAME", "--testcase_input FILENAME", "input of testcase") {|v| res[:testcase_input] = v}
    opt.on("-o FILENAME", "--testcase_output1 FILENAME", "output of testcase for command1") {|v| res[:testcase_output1] = v}
    opt.on("-O FILENAME", "--testcase_output2 FILENAME", "output of testcase for command2") {|v| res[:testcase_output2] = v}
    opt.on("-L VALUE", "--max_length VALUE", Integer, "max length of testcase to print stdout") {|v| res[:max_length] = v}
    opt.on("-T VALUE", "--threads VALUE", Integer, "number of threads") {|v|
      if v <= 0 then
        puts "Number of threads must be positive."
        exit 1
      end
      res[:threads] = v
    }

    files = opt.permute ARGV
    if !files.size.between? 2, 3 then
      puts "Number of arguments is not correct."
      exit 1
    end
    res[:input_generator] = files[0]
    res[:command1] = files[1]
    res[:command2] = files[2]
  end

  res
end

def generate_testcase(input_generator)
  testcase, status = Open3.capture2 input_generator
  if status != 0 then
    puts
    puts "Generator caused error."
    exit 1
  end
  testcase
end

def run_cmd(cmd, testcase, fin, fout, max_length)
  out, err, status = Open3.capture3 cmd, :stdin_data=>testcase
  if status != 0 then
    puts
    puts "Status of #{cmd} was #{status}."
    write_output testcase, "input", fin, max_length
    write_output out, "output", fout, max_length
    exit 2
  end
  out
end

def compare_output(cmd1, cmd2, out1, out2, testcase, fin, fout1, fout2, maxlen)
  return if out1 == out2

  puts
  write_output testcase, "input", fin, maxlen
  write_output out1, "output from #{cmd1}", fout1, maxlen
  write_output out2, "output from #{cmd2}", fout2, maxlen
  exit 3
end

def write_output(str, type, path, max_length)
  if str.size > max_length && path.nil? then
    puts "#{type.capitalize} is too long."
  else
    puts "--- #{type} ---"
    if str.size <= max_length then
      puts str
    end
    if !path.nil? then
      File.open(path, "w") do |f|
        f.print str
      end
      puts if str.size <= max_length
      puts "#{type.capitalize} was wrote at #{path}."
    end
  end
end

main if __FILE__ == $0
