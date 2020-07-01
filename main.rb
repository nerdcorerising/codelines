#!/usr/bin/ruby

require './code_types'

$code_types = [ CppCode.new,
                CSharpCode.new,
                Python.new,
                ShellScript.new,
                BatchFile.new,
                Assembly.new,
                Xml.new,
                MSBuild.new,
                CMake.new ]
$code_lines = { }

$code_types.each do |code_type|
    $code_lines[code_type] = {
        :whitespace => 0,
        :comment => 0,
        :code => 0,
        :files => 0 }
end

if ARGV.length < 1
    puts 'Please pass directory as argument'
    return
end

def add_commas(num)
    num_str = num.to_s.reverse
    comma_str = ""
    count = 0
    while count < num_str.length
        comma_str.insert(0, num_str[count])
        count += 1
        if count % 3 == 0 && count < num_str.length
            comma_str.insert(0, ',')
        end
    end

    return comma_str
end

def pad_string(str, count)
    if str.length >= count
        return str
    end

    padded = ' ' * (count - str.length)
    padded << str
    return padded
end

def parse_file(file, code_type)
    lines = File.open(file)
    $code_lines[code_type][:files] += 1
    in_comment = false
    lines.each_line do |line|
        if (in_comment)
            $code_lines[code_type][:comment] += 1

            if (code_type.ends_multiline_comment(line))
                in_comment = false
            end
        else
            case code_type.classify(line)
            when :whitespace
                $code_lines[code_type][:whitespace] += 1
            when :comment
                $code_lines[code_type][:comment] += 1
            when :code
                $code_lines[code_type][:code] += 1
            end

            # Can always start and end a /* style comment on the same line
            if (code_type.starts_multiline_comment(line) && !code_type.ends_multiline_comment(line))
                in_comment = true
            end
        end
    end
end

path = ARGV[0]
puts "Searching #{path}"

Dir.chdir(path)
Dir.glob("**/*").each do |sub_entry|
    if File.file?(sub_entry)
        $code_types.each do |code_type|
            if (code_type.is_this_code_type(File.basename(sub_entry)))
                parse_file(sub_entry, code_type)
                next
            end
        end
    end
end

$code_types.each do |code_type|
    code_formatted = add_commas($code_lines[code_type][:code])
    comments_formatted = add_commas($code_lines[code_type][:comment])
    whitespace_formatted = add_commas($code_lines[code_type][:whitespace])

    # Include the 12 so all code with pad to 12 characters by default, unless there is a really
    # huge code number all the different code types will be aligned
    longest = [ code_formatted.length, comments_formatted.length, whitespace_formatted.length, 12 ].max

    puts "Code type: #{code_type.name} (#{add_commas($code_lines[code_type][:files])} total files)"
    puts "    Code:       #{pad_string(code_formatted, longest)}"
    puts "    Comments:   #{pad_string(comments_formatted, longest)}"
    puts "    Whitespace: #{pad_string(whitespace_formatted, longest)}"
end
