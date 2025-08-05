#!/usr/bin/env ruby

filepath = ARGV[0]
deps_module = ARGV[1]
inflections_path = ARGV[2]

def parse(str, spaces, acronyms)
  method, klass_base = if str.include?(':')
                         [str.split(':').first, str.split(':').last.strip]
                       else
                         [str.split('.').last, str]
                       end
  klass = klass_base
            .gsub(/_\w/) { |s| s[1].upcase }
            .gsub(/\.\w/) { |s| "::" + s[1].upcase }
  klass = klass[0].upcase + klass[1..]
  acronyms.each do |a|
    a1 = a.downcase
    klass.gsub!(a1[0].upcase + a1[1..], a)
  end
  "#{spaces}# @!attribute #{method}\n#{spaces}#   @return [#{klass}]"
end

def append_yardoc_to_file(filepath, yardoc, position, spaces)
  content = File.read(filepath)
  di_block_start = "\n#{spaces}# DI"

  di_block_regexp = /#{di_block_start}.+\/DI\n/m

  old_di_block = content.match(di_block_regexp)
  new_di_block = "#{di_block_start}\n#{yardoc}\n#{spaces}# /DI\n"

  if old_di_block
    return if old_di_block[0] == new_di_block
    content.gsub!(di_block_regexp, '')
  end

  content.insert(position, new_di_block)

  File.open(filepath, 'w') { |f| f.write(content) }
end

def parse_inflections(inflections_path)
  content = File.read(inflections_path)
  content.scan(/inflect.acronym ['"](\w+)["']/).flatten
end

if !filepath
  puts "Usage: #{__FILE__} <filepath> <deps_module> <inflections_path?>"
  return
end

if File.exist?(filepath)
  content = File.read(filepath)
  acronyms = parse_inflections(inflections_path) if inflections_path
  acronyms ||= []

  deps = content.match(/#{deps_module}\[([\s|'|"|\w|\.|\:|,]*)\]/)
  return if deps.nil? || deps.size < 2

  deps = deps[1]

  spaces = content.match(/\n( *)include #{deps_module}/)
  spaces = if spaces
             spaces[1]
           else
             ''
           end

  yardoc = deps.split(',').map(&:strip).reject(&:empty?).map do |d|
    next if d.strip.empty?
    parse(d.gsub(/["']/, '').strip, spaces, acronyms)
  end.join("\n")

  position = content.index(deps) + deps.size + 2

  append_yardoc_to_file(filepath, yardoc, position, spaces)
else
  puts "#{filepath} does not exist"
end
