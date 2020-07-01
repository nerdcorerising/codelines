
class CodeType
    def is_whitespace(line)
        return line.strip.empty?
    end

    def classify(line)
        if is_whitespace(line)
            return :whitespace
        elsif is_comment(line)
            return :comment
        else
            return :code
        end
    end
end

class CStyleCommentCodeType < CodeType
    def is_comment(line)
        line.strip!
        return line.start_with?('//') || line.start_with?('/*')
    end

    # Techinically in C/C++ you can extend a single line '//' style comment with a '\'
    # at the end of the line, but who does that?
    def starts_multiline_comment(line)
        return line.include?('/*')
    end

    def ends_multiline_comment(line)
        return line.include?('*/')
    end
end

class CppCode < CStyleCommentCodeType
    @@cpp_exts = [ '.h', '.hpp', '.hxx', '.cpp', '.cxx', '.cc', '.c' ]

    def name
        return 'C/C++'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return @@cpp_exts.include?(extension)
    end
end

class CSharpCode < CStyleCommentCodeType
    def name
        return 'C#'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.cs'
    end
end

class ShellScript < CodeType
    def name
        return 'Shell'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.sh'
    end

    def is_comment(line)
        return line.strip.start_with?('#')
    end

    def starts_multiline_comment(line)
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end

class Python < CodeType
    def name
        return 'Python'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.py'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#') || line.start_with?('\"\"\"') || line.start_with?('\'\'\'')
    end

    def starts_multiline_comment(line)
        return line.include?('\"\"\"') || line.include?('\'\'\'')
    end

    def ends_multiline_comment(line)
        return line.include?('\"\"\"') || line.include?('\'\'\'')
    end
end

class BatchFile < CodeType
    def name
        return 'Batch File'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.cmd' || extension == '.bat'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('rem') || line.start_with?('::')
    end

    def starts_multiline_comment(line)
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end

class Assembly < CodeType
    def name
        return 'Assembly'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.s' || extension == '.asm'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#') || line.start_with?(';')
    end

    def starts_multiline_comment(line)
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end

class Xml < CodeType
    def name
        return 'XML'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension.downcase == '.xml'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('<!')
    end

    def starts_multiline_comment(line)
        # Ugh, don't want to deal with xml style comments since I'd have to keep track of
        # nesting to know
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end

class MSBuild < CodeType
    @@msbuild_exts = [ '.csproj', '.proj', '.ilproj', '.targets', '.props'  ]

    def name
        return 'MSBuild'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return @@msbuild_exts.include?(extension.downcase)
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('<!')
    end

    def starts_multiline_comment(line)
        # Ugh, don't want to deal with xml style comments since I'd have to keep track of
        # nesting to know
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end

class CMake < CodeType
    @@msbuild_exts = [ '.csproj', '.proj', '.ilproj', '.targets', '.props'  ]

    def name
        return 'CMake'
    end

    def is_this_code_type(file_name)
        return file_name.downcase == 'cmakelists.txt'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#')
    end

    def starts_multiline_comment(line)
        return false
    end

    def ends_multiline_comment(line)
        return false
    end
end
